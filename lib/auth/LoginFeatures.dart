import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final response = await http.post(
      Uri.parse('https://hs-cinemagix.duckdns.org/api/v1/user/login'), // 백엔드 API URL
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {

      int userId = responseData['userDetailDTO']['user_id'];
      String userName = responseData['userDetailDTO']['username'];
      String userEmail = responseData['userDetailDTO']['email'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('username', userName);
      await prefs.setString('email', userEmail);
      await prefs.setBool('isLoggedIn', true);
      await DialogMaker.dialog(context, '로그인 성공!', '환영합니다! $userName님');
      Navigator.pushNamed(context, '/recommendpage');
    } else {
      DialogMaker.dialog(context, '로그인 실패', '에러 코드: ${response.statusCode}');
    }
  }
}
