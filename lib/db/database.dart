import 'dart:async';
import 'package:mutex/mutex.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';

import 'dao/assignment_dao.dart';
import 'dao/attachment_dao.dart';
import 'entity/assignment_entity.dart';
import 'entity/attachment_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [AssignmentEntity, AttachmentEntity])
abstract class AppDatabase extends FloorDatabase {

  AssignmentDao get assignmentDao;

  AttachmentDao get attachmentDao;

}

AppDatabase? _instance;
final _mutex = Mutex();

Future<AppDatabase> getDatabase() async {
  final db = await _mutex.protect(() async {
    _instance ??= await $FloorAppDatabase.databaseBuilder("app.db").build();
    return _instance!;
  });
  return db;
}