import 'package:assignmate/db/entity/reminder_entity.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/model/firestore_document.dart';

class Reminder implements FirestoreDocument {
  @override
  String id;

  final String content;
  final DateTime creationDate;
  final bool isRead;

  Reminder({required this.id, required this.content, required this.creationDate, this.isRead = false});

  @override
  Map<String, dynamic> toFirestoreStructure() {
    return {
      "id": id,
      "content": content,
      "isRead": isRead,
      "creationDate": creationDate.date(),
    };
  }
}

extension ModelToEntity on Reminder {

  ReminderEntity toEntity() {
    return ReminderEntity(
      id: id,
      content: content,
      isRead: isRead,
      creationDate: creationDate.date()
    );
  }
}
