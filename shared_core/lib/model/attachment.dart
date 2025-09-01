import 'firestore_document.dart';

class Attachment implements FirestoreDocument {
  @override
  String id;

  final String driveFileId;
  final String filename;
  final Uri uri;

  Attachment({
    required this.id,
    required this.driveFileId,
    required this.filename,
    required this.uri,
  });

  @override
  Map<String, dynamic> toFirestoreStructure() {
    return {
      "id": id,
      "driveFileId": driveFileId,
      "filename": filename,
      "uri": uri.toString()
    };
  }
}