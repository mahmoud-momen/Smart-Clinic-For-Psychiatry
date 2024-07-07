import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message,
      {bool isCancelable = false}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(
                message,
                style: TextStyle(fontSize: 18.sp),
              ),
            ],
          ),
        );
      },
      barrierDismissible: isCancelable,
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String? posActionName,
        VoidCallback? posAction,
        VoidCallback? negAction,
        String? negActionName,
        bool isCancelable = false}) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          posAction?.call();
        },
        child: Text(
          posActionName,
          style: TextStyle(fontSize: 18.sp),
        ),
      ));
    }

    if (negActionName != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.pop(context);
          negAction?.call();
        },
        child: Text(
          negActionName,
          style: TextStyle(fontSize: 18.sp),
        ),
      ));
    }

    showDialog(
        context: context,
        barrierDismissible: isCancelable = false,
        builder: ((context) {
          return AlertDialog(
            content: Text(
              message,
              style: TextStyle(fontSize: 24.sp),
            ),
            actions: actions,
          );
        }));
  }
}
