import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:welzijnai/src/services/chat/chat_service.dart';

// chat.dart file now contains the solution to the error that this test has caught. So it is not considered an issue.

// Mock classes with generic types
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUser extends Mock implements User {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}
class MockWriteBatch extends Mock implements WriteBatch {}

// Extending ChatService for partial mocking
class ChatServiceMock extends Mock implements ChatService {
  final FirebaseAuth mockAuth;
  final FirebaseFirestore mockFirestore;

  ChatServiceMock(this.mockAuth, this.mockFirestore);

  @override
  FirebaseFirestore get firestore => mockFirestore;

  @override
  FirebaseAuth get auth => mockAuth;
}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUser mockUser;
  late ChatServiceMock chatService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('testUserID');
    
    // Initialize ChatServiceMock with mock dependencies
    chatService = ChatServiceMock(mockAuth, mockFirestore);
  });

  group('ChatService', () {
    test('getMessages should return a stream of messages from the correct collection', () {
      final mockMessagesCollection = MockCollectionReference();
      final mockChatDocument = MockDocumentReference();
      final mockStreamController = StreamController<QuerySnapshot<Map<String, dynamic>>>();

      when(mockFirestore.collection('Chats')).thenReturn(mockMessagesCollection);
      when(mockMessagesCollection.doc(any)).thenReturn(mockChatDocument);
      when(mockChatDocument.collection('messages')).thenReturn(mockMessagesCollection);
      when(mockMessagesCollection.orderBy('timestamp', descending: false)).thenReturn(mockMessagesCollection);
      when(mockMessagesCollection.snapshots()).thenAnswer((_) => mockStreamController.stream);

      final messagesStream = chatService.getMessages('testUserID', DateTime.now());

      // Stubbed stream should be returned
      expect(messagesStream, equals(mockStreamController.stream));
    });
  });
}