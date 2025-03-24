import 'dart:convert';
import 'package:flutter/material.dart';
import '../Common/DialogMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginFeatures {
  static Future<void> login({
    required BuildContext context,
    required final String email,
    required final String password,
  }) async {
    final String url = kIsWeb // 백엔드 API URL 설정
        ? 'http://localhost:8080/api/v1/user/login'
        : Platform.isAndroid
        ? 'http://10.0.2.2:8080/api/v1/user/login'
        : 'http://localhost:8080/api/v1/user/login';
    final response = await http.post(
      Uri.parse(url),
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
