import 'dart:typed_data';

import '../model/attachment.dart';

abstract interface class GoogleApiClient {
  Future<AuthResult> trySignIn();

  Future<AuthResult> signIn();

  Future<void> signOut();

  Future<Attachment> createFile({
    required String name,
    required String parentFolder,
    required Uint8List data,
  });

  Future<String?> getOrCreateFolder(String folderName, String parentId);

  Future<Uri> downloadFile(String url, String filename);

  Future<void> deleteFile(String fileId);

  Future<void> renameFolder(String oldName, String newName);
}

sealed class AuthResult {}

class Success extends AuthResult {
  final String email;
  final String name;

  Success(this.email, this.name);
}

class NoAdminFailure extends AuthResult {}

class GenericFailure extends AuthResult {
  final Exception exception;

  GenericFailure(this.exception);
}
