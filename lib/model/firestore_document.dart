abstract interface class FirestoreDocument {
  String id;

  FirestoreDocument({required this.id});

  Map<String, dynamic> toFirestoreStructure();
}