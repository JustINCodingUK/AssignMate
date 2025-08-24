import 'dart:io';

import 'package:assignmate/ext/filename.dart';
import 'package:assignmate/model/attachment.dart';
import 'package:assignmate/network/firestore_client.dart';

import '../network/google_api_client.dart';

class AttachmentRepository {
  final FirestoreClient<Attachment> _firestoreClient;
  final GoogleApiClient _driveClient;

  AttachmentRepository(this._firestoreClient, this._driveClient);

  Future<List<Attachment>> uploadFiles(
    String assignmentFolderTitle,
    List<File> files,
  ) async {
    final list = <Attachment>[];
    for (File file in files) {
      final data = await file.readAsBytes();
      final driveFile = await _driveClient.createFile(
        name: file.name,
        parentFolder: assignmentFolderTitle,
        data: data,
      );
      final attachment = await _firestoreClient.createDocument(driveFile);
      list.add(attachment);
    }
    return list;
  }

  Future<void> deleteAttachment(String id, String driveFileId) async {
    await _driveClient.deleteFile(driveFileId);
    await _firestoreClient.deleteDocument(id);
  }

  Future<void> renameFolder(String oldName, String newName) async {
    await _driveClient.renameFolder(oldName, newName);
  }

  Future<File> getAttachment(Attachment attachment) async {
    final data = await _driveClient.downloadFile(attachment.uri.toString(), attachment.filename);
    return File(data.path);
  }
}
