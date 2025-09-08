import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
FirebaseFirestore db = FirebaseFirestore.instance;

class DatabaseManager {
  final CollectionReference userCollection =
      db.collection('users'); // Collection reference
  final CollectionReference chatCollection =
      db.collection('chats');//.orderBy("time", descending: true); // Collection reference
      // db.collection('chats').orderBy("time", descending: true); // Collection reference

    Query chatsQuery = db.collection('chats').orderBy("time", descending: true);

  Future<void> newUser(String name, String chat, String time) async {
    final docRef = userCollection.doc(); //auto-generate id
    String userId = docRef.id;
    return await userCollection
        .doc(userId)
        .set({'name': name, 'chat': chat, 'time': time});
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await userCollection.doc(uid).get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    return await userCollection.doc(uid).update(data);
  }

  Future<void> deleteUser(String uid) async {
    return await userCollection.doc(uid).delete();
  }

  Future<List> getAllUsers() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> newChat(String text) async {
    final docRef = chatCollection.doc(); //auto-generate id
    String chatId = docRef.id;
    return await chatCollection
        .doc(chatId)
        .set({'chat': text, 'time': DateFormat('yyyy-MM-dd, hh:mm:ss').format(DateTime.now())});
  }

  Future<List> getAllChats() async { //not ordered
    QuerySnapshot querySnapshot = await chatCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List> getChatsQuery() async { //ordered by time descending
    QuerySnapshot querySnapshot = await chatsQuery.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }


}