import 'package:appwrite/appwrite.dart';

import '../constants.dart' as constants;
import '../model/todo.dart';
import '../services/appwrite.dart';

class TodosService {
  final Databases _databases = Databases(Appwrite.instance.client);

  Future<List<Todo>> fetch() async {
    final documentList = await _databases.listDocuments(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwritecollectionId,
    );
    return documentList.documents.map((d) => Todo.fromMap(d.data)).toList();
  }

  Future<Todo> create({required String content}) async {
    final document = await _databases.createDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwritecollectionId,
      documentId: ID.unique(),
      data: {"content": content},
    );

    return Todo.fromMap(document.data);
  }

  Future<Todo> update({required Todo todo}) async {
    final document = await _databases.updateDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwritecollectionId,
      documentId: todo.id,
      data: todo.toMap(),
    );

    return Todo.fromMap(document.data);
  }

  // function to delete all todos
  Future<void> deleteAll() async {
    final documentList = await _databases.listDocuments(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwritecollectionId,
    );
    for (var i = 0; i < documentList.documents.length; i++) {
      await _databases.deleteDocument(
        databaseId: constants.appwriteDatabaseId,
        collectionId: constants.appwritecollectionId,
        documentId: documentList.documents[i].$id,
      );
    }
  }

  Future<void> delete({required String id}) async {
    return _databases.deleteDocument(
      databaseId: constants.appwriteDatabaseId,
      collectionId: constants.appwritecollectionId,
      documentId: id,
    );
  }
}
