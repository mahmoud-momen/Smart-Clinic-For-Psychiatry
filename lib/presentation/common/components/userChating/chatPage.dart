import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/data/datasource/AuthenticationOnlineDataSource.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/userChating/chat_bubble.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/userChating/chat_service.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final AuthenticationOnlineDataSource authDataSource;
  final ChatService _chatService = ChatService(); // Initialize the ChatService
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  ChatPage(
      {Key? key,
        required this.receiverEmail,
        required this.receiverID,
        required this.authDataSource})
      : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          receiverID, _messageController.text); // Pass senderID
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.isDarkMode()
                ? [const Color(0xff121212), const Color(0xffEFE9F4)]
                : [const Color(0xff5078F2), const Color(0xffEFE9F4)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      )),
                  SizedBox(width: 75),
                  Text(
                    receiverEmail,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildMessageList(),
            ),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final String senderID = _auth.currentUser!.uid; // Get current user ID

    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Convert QuerySnapshot to a list of DocumentSnapshots
        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Map each DocumentSnapshot to a widget using _buildMessageItem
        final List<Widget> messageWidgets = documents.map((doc) {
          return _buildMessageItem(doc);
        }).toList();

        // Display the list of message widgets in a ListView
        return ListView(
          children: messageWidgets,
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> MyUser = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = MyUser['senderID'] == _auth.currentUser?.uid;
    var alignment = isCurrentUser ? Alignment.topRight : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(isCurrentUser: isCurrentUser, message: MyUser['message'])
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          hintStyle: TextStyle(fontSize: 18),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: MyTheme.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
