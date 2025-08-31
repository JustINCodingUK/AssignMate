// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AssignmentDao? _assignmentDaoInstance;

  AttachmentDao? _attachmentDaoInstance;

  RemindersDao? _reminderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AssignmentEntity` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `subject` TEXT NOT NULL, `description` TEXT NOT NULL, `recordingId` TEXT, `dueDate` TEXT NOT NULL, `isCompleted` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AttachmentEntity` (`id` TEXT NOT NULL, `assignmentId` TEXT NOT NULL, `driveFileId` TEXT NOT NULL, `filename` TEXT NOT NULL, `uri` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ReminderEntity` (`id` TEXT NOT NULL, `content` TEXT NOT NULL, `isRead` INTEGER NOT NULL, `creationDate` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AssignmentDao get assignmentDao {
    return _assignmentDaoInstance ??= _$AssignmentDao(database, changeListener);
  }

  @override
  AttachmentDao get attachmentDao {
    return _attachmentDaoInstance ??= _$AttachmentDao(database, changeListener);
  }

  @override
  RemindersDao get reminderDao {
    return _reminderDaoInstance ??= _$RemindersDao(database, changeListener);
  }
}

class _$AssignmentDao extends AssignmentDao {
  _$AssignmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _assignmentEntityInsertionAdapter = InsertionAdapter(
            database,
            'AssignmentEntity',
            (AssignmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'subject': item.subject,
                  'description': item.description,
                  'recordingId': item.recordingId,
                  'dueDate': item.dueDate,
                  'isCompleted': item.isCompleted ? 1 : 0
                },
            changeListener),
        _assignmentEntityUpdateAdapter = UpdateAdapter(
            database,
            'AssignmentEntity',
            ['id'],
            (AssignmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'subject': item.subject,
                  'description': item.description,
                  'recordingId': item.recordingId,
                  'dueDate': item.dueDate,
                  'isCompleted': item.isCompleted ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AssignmentEntity> _assignmentEntityInsertionAdapter;

  final UpdateAdapter<AssignmentEntity> _assignmentEntityUpdateAdapter;

  @override
  Future<List<AssignmentEntity>> getAllAssignments() async {
    return _queryAdapter.queryList('SELECT * FROM AssignmentEntity',
        mapper: (Map<String, Object?> row) => AssignmentEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            subject: row['subject'] as String,
            description: row['description'] as String,
            recordingId: row['recordingId'] as String?,
            dueDate: row['dueDate'] as String,
            isCompleted: (row['isCompleted'] as int) != 0));
  }

  @override
  Stream<AssignmentEntity?> getAssignments(bool isCompleted) {
    return _queryAdapter.queryStream(
        'SELECT * FROM AssignmentEntity WHERE isCompleted = ?1',
        mapper: (Map<String, Object?> row) => AssignmentEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            subject: row['subject'] as String,
            description: row['description'] as String,
            recordingId: row['recordingId'] as String?,
            dueDate: row['dueDate'] as String,
            isCompleted: (row['isCompleted'] as int) != 0),
        arguments: [isCompleted ? 1 : 0],
        queryableName: 'AssignmentEntity',
        isView: false);
  }

  @override
  Future<AssignmentEntity?> getAssignmentById(String id) async {
    return _queryAdapter.query('SELECT * FROM AssignmentEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AssignmentEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            subject: row['subject'] as String,
            description: row['description'] as String,
            recordingId: row['recordingId'] as String?,
            dueDate: row['dueDate'] as String,
            isCompleted: (row['isCompleted'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<int?> getAssignmentCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM AssignmentEntity',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteById(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM AssignmentEntity WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertAssignment(AssignmentEntity assignment) async {
    await _assignmentEntityInsertionAdapter.insert(
        assignment, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAssignment(AssignmentEntity assignment) async {
    await _assignmentEntityUpdateAdapter.update(
        assignment, OnConflictStrategy.abort);
  }
}

class _$AttachmentDao extends AttachmentDao {
  _$AttachmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attachmentEntityInsertionAdapter = InsertionAdapter(
            database,
            'AttachmentEntity',
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'assignmentId': item.assignmentId,
                  'driveFileId': item.driveFileId,
                  'filename': item.filename,
                  'uri': item.uri
                }),
        _attachmentEntityUpdateAdapter = UpdateAdapter(
            database,
            'AttachmentEntity',
            ['id'],
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'assignmentId': item.assignmentId,
                  'driveFileId': item.driveFileId,
                  'filename': item.filename,
                  'uri': item.uri
                }),
        _attachmentEntityDeletionAdapter = DeletionAdapter(
            database,
            'AttachmentEntity',
            ['id'],
            (AttachmentEntity item) => <String, Object?>{
                  'id': item.id,
                  'assignmentId': item.assignmentId,
                  'driveFileId': item.driveFileId,
                  'filename': item.filename,
                  'uri': item.uri
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentEntity> _attachmentEntityInsertionAdapter;

  final UpdateAdapter<AttachmentEntity> _attachmentEntityUpdateAdapter;

  final DeletionAdapter<AttachmentEntity> _attachmentEntityDeletionAdapter;

  @override
  Future<AttachmentEntity?> findAttachmentById(String id) async {
    return _queryAdapter.query('SELECT * FROM AttachmentEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            id: row['id'] as String,
            assignmentId: row['assignmentId'] as String,
            driveFileId: row['driveFileId'] as String,
            filename: row['filename'] as String,
            uri: row['uri'] as String),
        arguments: [id]);
  }

  @override
  Future<List<AttachmentEntity>> findAttachmentsByAssignmentId(
      String assignmentId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AttachmentEntity WHERE assignmentId = ?1',
        mapper: (Map<String, Object?> row) => AttachmentEntity(
            id: row['id'] as String,
            assignmentId: row['assignmentId'] as String,
            driveFileId: row['driveFileId'] as String,
            filename: row['filename'] as String,
            uri: row['uri'] as String),
        arguments: [assignmentId]);
  }

  @override
  Future<void> deleteByAssignmentId(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM AttachmentEntity WHERE assignmentId = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityInsertionAdapter.insert(
        attachment, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityUpdateAdapter.update(
        attachment, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAttachment(AttachmentEntity attachment) async {
    await _attachmentEntityDeletionAdapter.delete(attachment);
  }
}

class _$RemindersDao extends RemindersDao {
  _$RemindersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reminderEntityInsertionAdapter = InsertionAdapter(
            database,
            'ReminderEntity',
            (ReminderEntity item) => <String, Object?>{
                  'id': item.id,
                  'content': item.content,
                  'isRead': item.isRead ? 1 : 0,
                  'creationDate': item.creationDate
                }),
        _reminderEntityDeletionAdapter = DeletionAdapter(
            database,
            'ReminderEntity',
            ['id'],
            (ReminderEntity item) => <String, Object?>{
                  'id': item.id,
                  'content': item.content,
                  'isRead': item.isRead ? 1 : 0,
                  'creationDate': item.creationDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReminderEntity> _reminderEntityInsertionAdapter;

  final DeletionAdapter<ReminderEntity> _reminderEntityDeletionAdapter;

  @override
  Future<List<ReminderEntity>> getReminders() async {
    return _queryAdapter.queryList('SELECT * FROM ReminderEntity',
        mapper: (Map<String, Object?> row) => ReminderEntity(
            id: row['id'] as String,
            content: row['content'] as String,
            isRead: (row['isRead'] as int) != 0,
            creationDate: row['creationDate'] as String));
  }

  @override
  Future<int?> getUnreadRemindersCount() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM ReminderEntity WHERE isRead = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> markAllAsRead() async {
    await _queryAdapter
        .queryNoReturn('UPDATE ReminderEntity SET isRead = 1 WHERE isRead = 0');
  }

  @override
  Future<void> insertReminder(ReminderEntity reminder) async {
    await _reminderEntityInsertionAdapter.insert(
        reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReminder(ReminderEntity reminder) async {
    await _reminderEntityDeletionAdapter.delete(reminder);
  }
}
