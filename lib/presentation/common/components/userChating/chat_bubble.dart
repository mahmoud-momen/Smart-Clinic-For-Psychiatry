import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isCurrentUser,
    required this.message,
  }) : super(key: key);

  final bool isCurrentUser;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Color(0xff3660D9) : Color(0xffB4C9FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isCurrentUser ? Radius.circular(20) : Radius.circular(0),
            bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
