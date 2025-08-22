import 'dart:developer';

import 'package:assignmate/ext/attachment_ref.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/model/attachment.dart';
import 'package:assignmate/model/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClient<T extends FirestoreDocument> {
  final _firestore = FirebaseFirestore.instance;

  final collectionName = (T == Assignment) ? "assignments" : "attachments";

  Future<T> createDocument(T document) async {
    final id = _firestore.collection(collectionName).doc().id;

    document.id = id;

    final docFirestoreStructure = document.toFirestoreStructure();
    if (T == Assignment) {
      final firestoreReferenceStructure =
          (docFirestoreStructure["attachments"] as List<Attachment>).map((it) {
            final docRef = _firestore.collection("attachments").doc(it.id);
            return docRef;
          });

      docFirestoreStructure["attachments"] = firestoreReferenceStructure
          .toList();
    }

    await _firestore
        .collection(collectionName)
        .doc(id)
        .set(docFirestoreStructure);
    return document;
  }

  Future<void> editDocument(T document) async {
    final docFirestoreStructure = document.toFirestoreStructure();
    if(T == Assignment) {
      final firestoreReferenceStructure =
      (docFirestoreStructure["attachments"] as List<Attachment>).map((it) {
        final docRef = _firestore.collection("attachments").doc(it.id);
        return docRef;
      });

      docFirestoreStructure["attachments"] = firestoreReferenceStructure
          .toList();
    }
    await _firestore
        .collection(collectionName)
        .doc(document.id)
        .set(docFirestoreStructure);
  }

  Future<void> deleteDocument(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }

  Future<T> getDocument(String id) async {
    final snapshot = await _firestore.collection(collectionName).doc(id).get();

    final data = snapshot.data()!;
    if (T == Assignment) {
      final docRefs = (data["attachments"] as List).map((it) => it as DocumentReference<Map<String, dynamic>>).toList();
      final attachmentRefs = await docRefs.toAttachments();

      return Assignment(
            description: data["description"],
            id: data["id"],
            title: data["title"],
            subject: data["subject"],
            dueDate: DateTime.parse(data["dueDate"]),
            attachments: attachmentRefs,
          )
          as T;
    } else {
      return Attachment(
            id: data["id"],
            driveFileId: data["driveFileId"],
            filename: data["filename"],
            uri: data["uri"],
          )
          as T;
    }
  }

  Future<List<T>> getAllDocuments() async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    final newList = <T>[];
    for(final it in querySnapshot.docs) {
      final data = it.data();

      if (T == Assignment && data.keys.contains("title")) {
        log(data["attachments"].toString());
        final docRefs = (data["attachments"] as List).map((it) => it as DocumentReference<Map<String, dynamic>>).toList();
        final attachments = await docRefs.toAttachments();
        final assignment =  Assignment(
          id: data["id"],
          description: data["description"],
          title: data["title"],
          subject: data["subject"],
          dueDate: DateTime.now(),
          attachments: attachments,
        )
        as T;
        newList.add(assignment);
      } else {
        final attachment = Attachment(
          id: data["id"],
          driveFileId: data["driveFileId"],
          filename: data["filename"],
          uri: Uri.parse(data["uri"]),
        )
        as T;
        newList.add(attachment);
      }
    }
    return newList;
  }
}
