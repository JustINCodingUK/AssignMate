import '../dao/attachment_dao.dart';
import 'attachment_entity.dart';
import '../../ext/date.dart';
import '../../model/attachment.dart';
import 'package:floor/floor.dart';

import '../../model/assignment.dart';

@entity
class AssignmentEntity {
  @primaryKey
  String id;
  final String title;
  final String subject;
  final String description;
  final String? recordingId;
  final String dueDate;
  final bool isCompleted;

  AssignmentEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    this.recordingId,
    required this.dueDate,
    required this.isCompleted,
  });
}

extension EntityToModel on AssignmentEntity {
  Future<Assignment> toModel(AttachmentDao dao) async {
    final attachments = await dao.findAttachmentsByAssignmentId(id);
    Attachment? recording;

    if(recordingId != null) {
      final recordingAttachment = await dao.findAttachmentById(recordingId!);
      recording = recordingAttachment?.toModel();
    }

    return Assignment(
      id: id,
      title: title,
      subject: subject,
      description: description,
      dueDate: dueDate.asDate(),
      recording: recording,
      attachments: attachments.map((it) => it.toModel()).toList(),
      isCompleted: isCompleted
    );
  }
}
