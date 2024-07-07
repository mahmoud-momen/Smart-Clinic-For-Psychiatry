import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/chatBotModel/ChatBotMessageModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/chatBot/bloc/chat_bloc.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import '../../../provider/app_config_provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  String? _userPicture;
  late TextEditingController textEditingController;
  late final ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    chatBloc = ChatBloc();
    _getUserPicture();
  }

  Future<void> _getUserPicture() async {
    // Check if a user is signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Handle the case where no user is signed in
    }

    final String uId = user.uid; // Use actual logic to get ID

    final picture = await FirebaseUtils.getUserProfileImage(uId);
    setState(() {
      _userPicture = picture;
      // Log the retrieved name
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    chatBloc.close();
    super.dispose();
  }

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
                ? [const Color(0xff121212), const Color(0xffEFE9F4)]
                : [const Color(0xff5078F2), const Color(0xffEFE9F4)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.arrow_back,
                      color: MyTheme.whiteColor,
                      size: 40,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Text(
                      'Chat Bot',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: MyTheme.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                bloc: chatBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case const (ChatSuccessState):
                      List<ChatBotMessageModel> messages =
                          (state as ChatSuccessState).messages;
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final isUserMessage = message.role == "user";
                                final bubbleColor = isUserMessage
                                    ? MyTheme.primaryLight
                                    : MyTheme.darkPinkColor;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUserMessage) // Display model's avatar if it's not a user message
                                      const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/chatbot_icon.jpg'),
                                        radius: 20,
                                      ),
                                    const SizedBox(
                                        width:
                                            8), // Add spacing between avatar and message bubble
                                    Expanded(
                                      child: Align(
                                        alignment: isUserMessage
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  isUserMessage ? 16 : 0),
                                              topRight: Radius.circular(
                                                  isUserMessage ? 0 : 16),
                                              bottomLeft:
                                                  const Radius.circular(16),
                                              bottomRight:
                                                  const Radius.circular(16),
                                            ),
                                            color: bubbleColor,
                                          ),
                                          child: Text(
                                            message.parts.first.text,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: isUserMessage
                                                  ? Colors.white
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (isUserMessage) // Display user's avatar if it's a user message
                                      CircleAvatar(
                                        backgroundImage: _userPicture != null
                                            ? NetworkImage(_userPicture!)
                                            : null,
                                      ),
                                    const SizedBox(
                                        width:
                                            8), // Add spacing between message bubble and avatar
                                  ],
                                );
                              },
                            )),
                            if (chatBloc.generating)
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Lottie.asset(
                                      'assets/images/loading.json')),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: TextField(
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'Ask AI something...',
                                        hintStyle: const TextStyle(fontSize: 18),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.blue),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),

                                      ),
                                    )

                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                ElevatedButton(
                                  onPressed: () {
                                    if (textEditingController.text.isNotEmpty) {
                                      String text = textEditingController.text;
                                      textEditingController.clear();
                                      chatBloc.add(
                                          ChatGenerateNewTextMessageEvent(
                                              inputMessage: text));
                                      textEditingController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    size: 25.0,
                                    color: provider.isDarkMode()
                                        ? MyTheme.primaryDark
                                        : MyTheme.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
