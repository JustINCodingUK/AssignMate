import '../ext/date.dart';
import 'attachment.dart';
import 'firestore_document.dart';

class Assignment implements FirestoreDocument {

  @override
  String id;

  final String title;
  final String subject;
  final String description;
  final List<Attachment> attachments;
  final Attachment? recording;
  final DateTime dueDate;
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    this.recording,
    required this.dueDate,
    required this.attachments,
    this.isCompleted = false,
  });

  @override
  Map<String, dynamic> toFirestoreStructure() {
    return {
      "id": id,
      "title": title,
      "subject": subject,
      "dueDate": dueDate.date(),
      "description": description,
      "isCompleted": isCompleted,
      "recording": recording?.uri.toString(),
      "attachments": attachments,
    };
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? subject,
    List<Attachment>? attachments,
    Attachment? recording,
    DateTime? dueDate,
    String? description,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      recording: recording ?? this.recording,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  String get assignmentFolderName {
    return "$subject: $title/${dueDate.date()}";
  }
}