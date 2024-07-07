
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffB4C9FF),
            borderRadius: BorderRadius.circular(12),

          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 50,),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.person, size: 50, color: Colors.blue.shade900,),

              Text(text, style: TextStyle(fontSize: 20, color: Colors.blue.shade900),),
            ],
          ),
        ),
      ),
    );
  }
}
