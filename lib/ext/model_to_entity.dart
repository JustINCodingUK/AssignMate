import 'package:assignmate/db/entity/assignment_entity.dart';
import 'package:assignmate/db/entity/attachment_entity.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/model/attachment.dart';

extension ModelToEntityAssignment on Assignment {
  AssignmentEntity toEntity() {
    return AssignmentEntity(
      id: id,
      title: title,
      subject: subject,
      description: description,
      recordingId: recording?.id,
      dueDate: dueDate.date(),
      isCompleted: isCompleted,
    );
  }
}

extension ModelToEntityAttachment on List<Attachment> {
  List<AttachmentEntity> toEntities(String assignmentId) {
    return map((it) {
      return AttachmentEntity(
        id: it.id,
        assignmentId: assignmentId,
        driveFileId: it.driveFileId,
        filename: it.filename,
        uri: it.uri.toString(),
      );
    }).toList();
  }
}
