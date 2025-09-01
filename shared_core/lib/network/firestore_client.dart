import '../model/firestore_document.dart';

abstract interface class FirestoreClient<T extends FirestoreDocument> {

  Future<T> createDocument(T document);

  Future<void> editDocument(T document);

  Future<void> deleteDocument(String id);

  Future<T> getDocument(String id);

  Future<List<T>> getAllDocuments();

}