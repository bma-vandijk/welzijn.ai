import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:welzijnai/models/message.dart';
import 'package:intl/intl.dart';

/// Chatservice
/// Provides options to store a message in the database, retieve
/// message or delete all messages sent at the current date
/// Filepath: lib/src/services/chat/chat_service.dart
class ChatService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> sendMessage(bool user, String message) async {
    // get current user
    final String senderID = auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    // create message
    Message newMessage = Message(
      user: user,
      message: message,
      timestamp: timestamp,
    );
    // Store message
    String chatID =
        "${senderID}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}";
    await firestore
        .collection("Chats")
        .doc(chatID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, DateTime date) {
    String chatID =
        "${auth.currentUser!.uid}_${DateFormat('dd-MM-yyyy').format(date)}";

    return firestore
        .collection("Chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Delete messages from the current day
  void refreshMessages(DateTime date) async {
    String chatID =
        "${auth.currentUser!.uid}_${DateFormat('dd-MM-yyyy').format(date)}";
    WriteBatch batch = firestore.batch();
    QuerySnapshot messagesSnapshot = await firestore
        .collection("Chats")
        .doc(chatID)
        .collection("messages")
        .get();

    for (DocumentSnapshot messageDoc in messagesSnapshot.docs) {
      batch.delete(messageDoc.reference);
    }

    batch.delete(firestore.collection("Chats").doc(chatID));

    await batch.commit();
  }
}
