import 'dart:typed_data';

import 'package:shared_core/model/attachment.dart';
import 'package:shared_core/network/google_api_client.dart';

class DesktopGoogleApiClient implements GoogleApiClient {

  DesktopGoogleApiClient() {
    throw UnimplementedError("This is not meant to be used on desktop");
  }

  @override
  Future<Attachment> createFile({
    required String name,
    required String parentFolder,
    required Uint8List data,
  }) {
    // TODO: implement createFile
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFile(String fileId) {
    // TODO: implement deleteFile
    throw UnimplementedError();
  }

  @override
  Future<Uri> downloadFile(String url, String filename) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future<String?> getOrCreateFolder(String folderName, String parentId) {
    // TODO: implement getOrCreateFolder
    throw UnimplementedError();
  }

  @override
  Future<void> renameFolder(String oldName, String newName) {
    // TODO: implement renameFolder
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> trySignIn() {
    // TODO: implement trySignIn
    throw UnimplementedError();
  }
}
