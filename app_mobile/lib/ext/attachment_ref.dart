import 'package:shared_core/model/attachment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension AttachmentRef on List<DocumentReference<Map<String, dynamic>>> {
  Future<List<Attachment>> toAttachments() async {
    final newList = <Attachment>[];
    for (final ref in this) {
      final doc = await ref.get();
      final data = doc.data()!;

      newList.add(
        Attachment(
          id: data["id"],
          driveFileId: data["driveFileId"],
          filename: data["filename"],
          uri: Uri.parse(data["uri"]),
        ),
      );
    }
    return newList;
  }
}
