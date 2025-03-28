import 'package:flutter/material.dart';

class DialogMaker {
  static Future<void> dialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // 다이얼로그 닫기
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

}