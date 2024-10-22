import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:welzijnai/models/history_data.dart';
import 'package:welzijnai/src/services/auth/auth_service.dart';

/// History service
/// Retrieves and sets the scores obtained from the questionnaire
/// stored in the database.
/// File path: lib/src/services/history/history_service.dart

class HistoryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AuthService auth = AuthService();

// Function to create or update document
  Future<void> syncHistory(HistoryData data) async {
    String userID = auth.getCurrentUser()!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('History')
        .doc(DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()))
        .set(data.toMap());
  }

  // Get the 7 most recent scores from the questionnaire
  Future<List<HistoryData>> getOverviewData() async {
    String userID = auth.getCurrentUser()!.uid;
    QuerySnapshot historySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('History')
        .orderBy("timestamp", descending: true)
        .limit(7)
        .get();
    List<HistoryData> historyDataList = historySnapshot.docs
        .map((doc) => HistoryData.fromFirestore(doc))
        .toList();
    return historyDataList;
  }

  // Get the scores from the questionnaire stored on the specified date
  Future<dynamic> getHistory(String date) async {
    String userID = auth.getCurrentUser()!.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(userID)
        .collection("History")
        .doc(date)
        .get();
    return snapshot.data()!;
  }

  // Get a list of all the dates on which a conversation has been started
  Future<List<String>> getHistoryDates() async {
    List<String> dates = [];
    String userID = auth.getCurrentUser()!.uid;

    QuerySnapshot historySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('History')
        .orderBy("timestamp", descending: true)
        .get();
    for (QueryDocumentSnapshot doc in historySnapshot.docs) {
      dates.add(doc.id);
    }

    return dates;
  }
}
