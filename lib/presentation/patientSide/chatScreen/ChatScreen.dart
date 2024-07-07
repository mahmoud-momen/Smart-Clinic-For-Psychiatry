import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:smart_clinic_for_psychiatry/data/datasource/AuthenticationOnlineDataSource.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/userChating/chatPage.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/userChating/chat_service.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/userChating/user_tile.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ChatScreen extends StatefulWidget {
  static String routeName = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatService _chatService = ChatService();

  // Create an instance of FirebaseUtils
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.isDarkMode()
                ? [const Color(0xff121212), const Color(0xff121212)]
                : [const Color(0xff5078F2), const Color(0xffEFE9F4)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 90.0, top: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.doctors_list,
                  style: TextStyle(
                    color: Colors.white, // Change text color to white
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: _buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Specify the type of snapshot
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((MyUser) => _buildUserListItem(MyUser, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> MyUser, BuildContext context) {
    if (MyUser['role'] != 'patient') {
      // Check if role is not "doctor"
      return UserTile(
        text: MyUser['name'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: MyUser['name'] ?? '',
                receiverID: MyUser['uid'] ?? '',
                authDataSource: AuthenticationOnlineDataSource(FirebaseUtils()),
              ),
            ),
          );
        },
      );
    } else {
      return SizedBox.shrink(); // Hide the widget if role is "doctor"
    }
  }
}
