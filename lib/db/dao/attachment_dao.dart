import 'package:assignmate/db/entity/attachment_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class AttachmentDao {

  @Query("SELECT * FROM AttachmentEntity WHERE id = :id")
  Future<AttachmentEntity?> findAttachmentById(String id);

  @Query("SELECT * FROM AttachmentEntity WHERE assignmentId = :assignmentId")
  Future<List<AttachmentEntity>> findAttachmentsByAssignmentId(String assignmentId);

  @Query("DELETE FROM AttachmentEntity WHERE assignmentId = :id")
  Future<void> deleteByAssignmentId(String id);
  
  @insert
  Future<void> insertAttachment(AttachmentEntity attachment);

  @update
  Future<void> updateAttachment(AttachmentEntity attachment);

  @delete
  Future<void> deleteAttachment(AttachmentEntity attachment);

}