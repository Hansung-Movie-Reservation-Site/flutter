import 'dart:convert';
import 'package:flutter/material.dart';
import '../Common/DialogMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:movie/auth/LoginPage.dart';

class SignupFeautures {
  static Future<void> signup({
    required BuildContext context,
    required final String username,
    required final String email,
    required final String password,
  }) async {
    final String url = kIsWeb // 백엔드 API URL 설정
        ? "http://localhost:8080/api/v1/user/createUser"
        : Platform.isAndroid
        ? "http://10.0.2.2:8080/api/v1/user/createUser"
        : "http://localhost:8080/api/v1/user/createUser";
    final response = await http.post(
      Uri.parse(url), // 백엔드 API URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      await DialogMaker.dialog(context, '회원가입 성공!', '이메일: $email\n 확인 코드: ${response.statusCode}');
      Navigator.pushNamed(context, 'LoginPage');
    } else {
      DialogMaker.dialog(context, '로그인 실패', '이메일: $email\n 에러 코드: ${response.statusCode}');
    }
  }

  //이메일 인증 코드 확인 함수
  static Future<bool> emailCheck ({
    required final String email,
    required final String verifyCode
  }) async {
    final String url = kIsWeb // 백엔드 API URL 설정
        ? 'http://localhost:8080/api/v1/user/check'
        : Platform.isAndroid
        ? 'http://10.0.2.2:8080/api/v1/user/check'
        : 'http://localhost:8080/api/v1/user/check';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": email,
        "authnum": verifyCode,
      }),
    );
    return response.statusCode == 200;
  }
}
