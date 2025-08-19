import 'package:floor/floor.dart';

import '../../model/attachment.dart';

@entity
class AttachmentEntity {

  @primaryKey String id;
  final String assignmentId;
  final String driveFileId;
  final String filename;
  final String uri;

  AttachmentEntity({
    required this.id,
    required this.assignmentId,
    required this.driveFileId,
    required this.filename,
    required this.uri,
  });

}

extension EntityToModel on AttachmentEntity {
  Attachment toModel() {
    return Attachment(
      id: id,
      driveFileId: driveFileId,
      filename: filename,
      uri: Uri.parse(uri),
    );
  }
}