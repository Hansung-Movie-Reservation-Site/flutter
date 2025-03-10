import 'dart:convert';
import 'package:flutter/material.dart';
import '../Common/DialogMaker.dart';
import 'package:http/http.dart' as http;

class LoginFeatures {
  static Future<void> login({
    required BuildContext context,
    required final String email,
    required final String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/user/login'), // 백엔드 API URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      DialogMaker.dialog(context, '로그인 성공!', '확인 코드: ${response.statusCode}');
    } else {
      DialogMaker.dialog(context, '로그인 실패', '이메일: $email\n 에러 코드: ${response.statusCode}');
    }
  }
}
