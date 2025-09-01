import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_core/model/assignment.dart';
import 'package:shared_core/model/attachment.dart';
import 'package:shared_core/model/firestore_document.dart';
import 'package:shared_core/model/reminder.dart';
import 'package:shared_core/network/firestore_client.dart';

import '../firebase_options.dart';

class DesktopFirestoreClient<T extends FirestoreDocument>
    implements FirestoreClient<T> {
  late final String collectionId;

  DesktopFirestoreClient() {
    switch (T) {
      case Assignment _:
        collectionId = "assignments";
        break;
      case Attachment _:
        collectionId = "attachments";
        break;
      case Reminder _:
        collectionId = "reminders";
        break;
    }
  }

  @override
  Future<List<T>> getAllDocuments() async {
    final url =
        "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collectionId";
    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return [];
    }
    final data =
        jsonDecode(response.body)["documents"] as List<Map<String, dynamic>>;
    return data.map(parseDocument).toList();
  }

  @override
  Future<T> getDocument(String id) async {
    final url =
        "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collectionId/$id";
    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Failed to get document");
    }

    final data = jsonDecode(response.body);
    return parseDocument(data);
  }

  T parseDocument(Map<String, dynamic> data) {
    final fields = data["fields"];
    switch (T) {
      case Assignment _:
        final attachmentRefs =
            fields["attachments"] as List<Map<String, String>>;
        final attachmentClient = DesktopFirestoreClient<Attachment>();
        final attachments = attachmentRefs
            .map((it) => attachmentClient.parseDocument(it))
            .toList();

        return Assignment(
              id: fields["id"]["stringValue"],
              title: fields["title"]["stringValue"],
              subject: fields["subject"]["stringValue"],
              description: fields["description"]["stringValue"],
              dueDate: fields["dueDate"]["stringValue"],
              attachments: attachments,
            )
            as T;
      case Attachment _:
        return Attachment(
              id: fields["id"]["stringValue"],
              driveFileId: fields["driveFileId"]["stringValue"],
              filename: fields["filename"]["stringValue"],
              uri: fields["uri"]["stringValue"],
            )
            as T;
      default:
        return Reminder(
              id: fields["id"]["stringValue"],
              content: fields["content"]["stringValue"],
              creationDate: fields["creationDate"]["stringValue"],
            )
            as T;
    }
  }

  @override
  Future<T> createDocument(T document) {
    throw UnimplementedError("Unsupported operation for desktop");
  }

  @override
  Future<void> deleteDocument(String id) {
    throw UnimplementedError("Unsupported operation for desktop");
  }

  @override
  Future<void> editDocument(T document) {
    throw UnimplementedError("Unsupported operation for desktop");
  }
}
