import 'package:assignmate/db/entity/assignment_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class AssignmentDao {
  @Query("SELECT * FROM AssignmentEntity")
  Future<List<AssignmentEntity>> getAllAssignments();

  @Query("SELECT * FROM AssignmentEntity WHERE isCompleted = :isCompleted")
  Stream<AssignmentEntity?> getAssignments(bool isCompleted);

  @Query("SELECT * FROM AssignmentEntity WHERE id = :id")
  Future<AssignmentEntity?> getAssignmentById(String id);

  @Query("SELECT COUNT(*) FROM AssignmentEntity")
  Future<int?> getAssignmentCount();

  @insert
  Future<void> insertAssignment(AssignmentEntity assignment);

  @update
  Future<void> updateAssignment(AssignmentEntity assignment);

  @delete
  Future<void> deleteAssignment(AssignmentEntity assignment);
}
