import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/chatModel/ChatModel.dart';



class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final MyUser = doc.data();
        return MyUser;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message,) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User not logged in");
      }
      final String currentUserID = currentUser.uid;
      final String currentUserEmail = currentUser.email!;
      final Timestamp timestamp = Timestamp.now();

      // Create a Message object with sender and receiver details
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
      );

      // Sort user IDs to create a unique chat room ID
      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Save the message in the chat room
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("message")
          .add(newMessage.toMap());

      print('Message sent successfully.');

    } catch (e) {
      print("Error sending message: $e");
    }
  }


  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    print('Chat room ID: $chatRoomID');

    Stream<QuerySnapshot> messagesStream = _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();

    messagesStream.listen((snapshot) {
      print('Received messages: ${snapshot.docs}');
    });

    return messagesStream;
  }


}
