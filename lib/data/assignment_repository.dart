import 'dart:developer';
import 'dart:io';

import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/db/entity/assignment_entity.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/model/attachment.dart';
import 'package:assignmate/network/firestore_client.dart';

class AssignmentsRepository {
  final FirestoreClient<Assignment> _firestoreClient;
  final AttachmentRepository _attachmentRepository;
  final AppDatabase db;
  AssignmentsRepository(this._firestoreClient, this._attachmentRepository, this.db);

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
    if (recording != null) {
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

  Future<void> editAssignment(
    Assignment assignment,
    Assignment oldAssignment,
  ) async {
    if (assignment.assignmentFolderName != oldAssignment.assignmentFolderName) {
      await _attachmentRepository.renameFolder(
        oldAssignment.assignmentFolderName,
        assignment.assignmentFolderName,
      );
    }

    final attachmentsToDelete = oldAssignment.attachments.where((it) {
      return !assignment.attachments.contains(it);
    });
    final attachmentsToAdd = assignment.attachments.where((it) {
      return !oldAssignment.attachments.contains(it);
    });

    for (Attachment attachment in attachmentsToDelete) {
      await _attachmentRepository.deleteAttachment(
        attachment.id,
        attachment.driveFileId,
      );
    }

    final newAttachments = await _attachmentRepository.uploadFiles(
      assignment.assignmentFolderName,
      attachmentsToAdd.map((it) => File(it.uri.path)).toList(),
    );

    Attachment? recording = oldAssignment.recording;

    if (oldAssignment.recording == null && assignment.recording != null) {
      final recordingAttachments = await _attachmentRepository.uploadFiles(
        assignment.assignmentFolderName,
        [File(assignment.recording!.uri.path)],
      );
      recording = recordingAttachments.first;
    }else if(oldAssignment.recording != null && assignment.recording != null) {
      if(oldAssignment.recording!.id != assignment.recording!.id) {
        final recordingAttachments = await _attachmentRepository.uploadFiles(
          assignment.assignmentFolderName,
          [File(assignment.recording!.uri.path)],
        );
        recording = recordingAttachments.first;
      }
    } else if(oldAssignment.recording != null && assignment.recording == null) {
      await _attachmentRepository.deleteAttachment(oldAssignment.recording!.id, oldAssignment.recording!.id);
      recording = null;
    }


    final newAssignment = assignment.copyWith(attachments: newAttachments, recording: recording);
    await _firestoreClient.editDocument(newAssignment);
  }

  Future<void> deleteAssignment(String id) async {
    final assignment = await _firestoreClient.getDocument(id);
    for (Attachment attachment in assignment.attachments) {
      _attachmentRepository.deleteAttachment(
        attachment.id,
        attachment.driveFileId,
      );
      _firestoreClient.deleteDocument(attachment.id);
    }
    _firestoreClient.deleteDocument(id);
  }

  Future<List<Assignment>> getAssignments() {
    final assignments = _firestoreClient.getAllDocuments();
    return assignments;
  }

  Stream<Assignment> getLocalAssignments() {
    return db.assignmentDao.getAllAssignments().asyncMap((it) async {
      final assignment = await it?.toModel(db.attachmentDao);
      return assignment!;
    });
  }

  Future<Assignment> getAssignment(String id) async {
    final assignmentEntity = await db.assignmentDao.getAssignmentById(id);
    final assignment = await assignmentEntity!.toModel(db.attachmentDao);
    return assignment;
  }

  Future<File> getAttachment(Attachment attachment) async {
    final recording = await _attachmentRepository.getAttachment(attachment);
    return recording;
  }
}
