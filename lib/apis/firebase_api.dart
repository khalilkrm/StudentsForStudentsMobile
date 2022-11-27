import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

class FirebaseApi {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> listenToCollection({
    required String collectionName,
    required void Function(QuerySnapshot<Map<String, dynamic>>) onData,
    required Function(dynamic) onError,
  }) {
    assert(collectionName.isNotEmpty);
    final collection = db.collection(collectionName);
    return collection.snapshots().listen(onData, onError: onError);
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenToDocument({
    required String collectionName,
    required String documentName,
    required void Function(DocumentSnapshot<Map<String, dynamic>>) onData,
    required Function(dynamic) onError,
  }) {
    assert(collectionName.isNotEmpty);
    assert(documentName.isNotEmpty);
    final collection = db.collection(collectionName);
    final document = collection.doc(documentName);
    return document.snapshots().listen(onData, onError: onError);
  }

  Future<Iterable<Map<String, dynamic>>> getCollection(
      {required String collectionName}) async {
    final snapchot = await db.collection(collectionName).get();
    return snapchot.docs.map((doc) => doc.data());
  }

  Future<Map<String, dynamic>> getDocument({
    required String collectionName,
    required String documentName,
  }) async {
    final doc = await db.collection(collectionName).doc(documentName).get();
    final data = doc.data();
    return data ?? {};
  }

  Future<void> updateArrayDocument({
    required String collectionName,
    required String documentName,
    required String fieldName,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionName).doc(documentName).update({
      fieldName: FieldValue.arrayUnion([data])
    });
  }

  Future<void> updateObjectDocument({
    required String collectionName,
    required String documentName,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collectionName).doc(documentName).update(data);
  }
}
