import 'dart:developer';
import 'dart:typed_data';

import 'package:shared_core/model/attachment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_core/network/google_api_client.dart';

class MobileGoogleApiClient implements GoogleApiClient {
  late drive.DriveApi _driveApi;
  final _scopes = ['email', drive.DriveApi.driveFileScope];
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AuthResult> trySignIn() async {
    await GoogleSignIn.instance.initialize();
    if (firebaseAuth.currentUser == null) {
      return GenericFailure(Exception());
    } else {
      final user = await GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (user == null) {
        return GenericFailure(Exception());
      } else {
        final authorization = await user.authorizationClient.authorizeScopes(
          _scopes,
        );
        final driveClient = authorization.authClient(scopes: _scopes);
        _driveApi = drive.DriveApi(driveClient);
      }
      return Success(
        firebaseAuth.currentUser!.email!,
        firebaseAuth.currentUser!.displayName!,
      );
    }
  }

  @override
  Future<AuthResult> signIn() async {
    await GoogleSignIn.instance.initialize();
    final googleSignIn = GoogleSignIn.instance;

    GoogleSignInAccount? account;

    account = await googleSignIn.authenticate(scopeHint: _scopes);

    final allowedAccounts = await firestore
        .collection("admin")
        .doc("M9CsgRtTLRydfiNU5f5A")
        .get();
    final data = allowedAccounts.data() ?? {};
    if (!data.values.contains(account.email)) {
      googleSignIn.signOut();
      return NoAdminFailure();
    }

    final googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final authResult = await firebaseAuth.signInWithCredential(credential);

    final authorization = await account.authorizationClient
        .authorizationForScopes(_scopes);
    final driveClient = authorization?.authClient(scopes: _scopes);
    _driveApi = drive.DriveApi(driveClient!);

    return Success(authResult.user!.email!, authResult.user!.displayName!);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  @override
  Future<Attachment> createFile({
    required String name,
    required String parentFolder,
    required Uint8List data,
  }) async {
    final rootAppFolder = await _getFolderID("AssignMate");
    final _assignmentFolderId = await getOrCreateFolder(
      parentFolder,
      rootAppFolder,
    );


    final file = drive.File()
      ..name = name
      ..parents = [_assignmentFolderId!]
      ..mimeType = _getMimeType(name);

    final media = drive.Media(Stream.value(data), data.length);

    final uploadedFile = await _driveApi.files.create(
      file,
      uploadMedia: media,
      $fields: 'id, name, mimeType, webViewLink, webContentLink',
    );
    await _driveApi.permissions.create(
      drive.Permission(type: 'anyone', role: 'reader'),
      uploadedFile.id!,
    );

    final uri = Uri.parse(uploadedFile.webViewLink!);

    return Attachment(
      id: "0",
      driveFileId: uploadedFile.id!,
      filename: uploadedFile.name!,
      uri: uri,
    );
  }

  @override
  Future<String?> getOrCreateFolder(
    String folderName,
    String parentId,
  ) async {
    final query =
        "name='$folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";
    final result = await _driveApi.files.list(q: query);

    if (result.files != null && result.files!.isNotEmpty) {
      // Folder exists
      return result.files!.first.id;
    } else {
      // Create folder
      final folder = drive.File()
        ..name = folderName
        ..mimeType = 'application/vnd.google-apps.folder'
        ..parents = [parentId];
      final newFolder = await _driveApi.files.create(folder);
      return newFolder.id;
    }
  }

  @override
  Future<Uri> downloadFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/$filename");

        await file.writeAsBytes(response.bodyBytes);
        return file.uri;
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error downloading file: $e");
    }
  }

  @override
  Future<void> deleteFile(String fileId) async {
    try {
      await _driveApi.files.delete(fileId);
    } catch(e) {}
  }

  @override
  Future<void> renameFolder(String oldName, String newName) async {
    final id = await _getFolderID(oldName);

    final folder = drive.File()..name = newName;

    await _driveApi.files.update(folder, id, $fields: "name");
  }

  Future<String> _getFolderID(String name) async {
    final query =
        "mimeType = 'application/vnd.google-apps.folder' and name = 'AssignMate'";
    final fileList = await _driveApi.files.list(
      q: query,
      $fields: "files(id, name)",
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id!;
    } else {
      final file = drive.File()
        ..name = "AssignMate"
        ..mimeType = "application/vnd.google-apps.folder";
      final createdFolder = await _driveApi.files.create(file);
      return createdFolder.id!;
    }
  }

  String _getMimeType(String name) {
    final parts = name.split('.');
    final ext = parts.last.toLowerCase();

    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpeg':
      case 'jpg':
        return 'image/jpeg';
      case 'pdf':
        return 'application/pdf';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }
}
