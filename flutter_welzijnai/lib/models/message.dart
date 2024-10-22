import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool user;
  final String message;
  final Timestamp timestamp;
  Message({
    required this.user,
    required this.message,
    required this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
