import 'dart:io';

import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/model/attachment.dart';
import 'package:assignmate/network/firestore_client.dart';

class AssignmentsRepository {
  final FirestoreClient<Assignment> _firestoreClient;
  final AttachmentRepository _attachmentRepository;

  AssignmentsRepository(this._firestoreClient, this._attachmentRepository);

  Future<Assignment> createAssignment(
    Assignment assignmentNoFiles,
    List<File> files,
    File? recording,
  ) async {
    final attachments = await _attachmentRepository.uploadFiles(
      assignmentNoFiles.assignmentFolderName,
      files,
    );

    Attachment? recordingAttachment;
    if(recording != null) {
      final recordingAttachments = await _attachmentRepository.uploadFiles(
        assignmentNoFiles.assignmentFolderName,
        [recording],
      );
      recordingAttachment = recordingAttachments.first;
    }
    final newAssignment = assignmentNoFiles.copyWith(
      attachments: attachments,
      recording: recordingAttachment,
    );
    final assignmentWithId = await _firestoreClient.createDocument(
      newAssignment,
    );
    return assignmentWithId;
  }

  Future<void> editAssignment(Assignment assignment) async {
    final oldAssignment = await _firestoreClient.getDocument(assignment.id);
    final attachmentsToDelete = oldAssignment.attachments
        .where(
          (oldAttachment) => !assignment.attachments.any(
            (newAttachment) => newAttachment.id == oldAttachment.id,
          ),
        )
        .toList();

    final filesToUpload = assignment.attachments
        .where((newAttachment) => newAttachment.id == null)
        .map((e) => File(e.uri.toFilePath()))
        .toList();

    for (final attachment in attachmentsToDelete) {
      await _attachmentRepository.deleteAttachment(attachment.driveFileId);
    }

    final uploadedAttachments = await _attachmentRepository.uploadFiles(
      assignment.assignmentFolderName,
      filesToUpload,
    );

    final updatedAssignment = assignment.copyWith(
      attachments: [
        ...assignment.attachments.where((element) => element.id != null),
        ...uploadedAttachments,
      ],
    );

    await _firestoreClient.editDocument(updatedAssignment);
  }

  Future<void> deleteAssignment(String id) async {
    final assignment = await _firestoreClient.getDocument(id);
    for (Attachment attachment in assignment.attachments) {
      _attachmentRepository.deleteAttachment(attachment.driveFileId);
      _firestoreClient.deleteDocument(attachment.id);
    }
    _firestoreClient.deleteDocument(id);
  }

  Future<List<Assignment>> getAssignments() {
    final assignments = _firestoreClient.getAllDocuments();
    return assignments;
  }

  Future<Assignment> getAssignment(String id) async {
    final assignment = await _firestoreClient.getDocument(id);
    return assignment;
  }

  Future<File> getAttachment(Attachment attachment) async {
    final recording = await _attachmentRepository.getAttachment(attachment);
    return recording;
  }
}
