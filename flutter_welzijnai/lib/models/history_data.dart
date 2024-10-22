import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryData {
  int mobility;
  int selfcare;
  int activities;
  int pain;
  int anxiety;
  Timestamp timestamp;

  HistoryData(
      {required this.mobility,
      required this.selfcare,
      required this.activities,
      required this.pain,
      required this.anxiety,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'mobility': mobility,
      'selfcare': selfcare,
      'activities': activities,
      'pain': pain,
      'anxiety': anxiety,
      'timestamp': timestamp
    };
  }

  factory HistoryData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return HistoryData(
      mobility: data['mobility'],
      selfcare: data['selfcare'],
      activities: data['activities'],
      pain: data['pain'],
      anxiety: data['anxiety'],
      timestamp: data['timestamp'],
    );
  }
}
