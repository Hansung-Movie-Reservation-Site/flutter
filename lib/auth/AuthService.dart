import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Common/DialogMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
/// 나중에 싹다 리팩터링해야함;; << 그럼 빨랑 하세요!
  static Future<Map<String, dynamic>?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');

    if (userId != null && username != null && email != null) {
      return {
        'user_id': userId,
        'username': username,
        'email': email,
      };
    }
    return null;
  }

  
  static Future<bool> isLoggedIn() async { //로그인 상태 확인
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    //로그아웃
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('username');
    await pref.remove('user_id');
    await pref.remove('email');
    await pref.setBool('isLoggedIn', false);
  }

  static Future<void> login({
    required BuildContext context,
    required final String email,
    required final String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://43.200.184.143:8080/api/v1/user/login'),
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

  ///이름 변경
  static Future<void> changeName({
    required BuildContext context,
    required final String password,
    required final String after,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    final response = await http.post(
      Uri.parse('http://43.200.184.143:8080/api/v1/detail/change/username'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "user_id": userId,
        "password": password,
        "after": after,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200 && responseData['code'] == 'SUCCESS') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', after);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      await DialogMaker.dialog(context, '변경 성공', '이름이 "$after"로 변경되었습니다.');
    } else {
      DialogMaker.dialog(context, '변경 실패', '에러 코드: ${response.statusCode}');
    }
  }

  ///비밀번호 변경
  static Future<void> changePassword({
    required BuildContext context,
    required final String password,
    required final String after,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    final response = await http.post(
      Uri.parse('http://43.200.184.143:8080/api/v1/detail/change/password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "user_id": userId,
        "password": password,
        "after": after,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200 && responseData['code'] == 'SUCCESS') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('password', after);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      await DialogMaker.dialog(context, '변경 성공', '비밀번호가 변경됬습니다..');
    } else {
      DialogMaker.dialog(context, '변경 실패', '에러 코드: ${response.statusCode}');
    }
  }

  static Future<void> changeEmail({
    required BuildContext context,
    required final String password,
    required final String after,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    final response = await http.post(
      Uri.parse('http://43.200.184.143:8080/api/v1/detail/change/email'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "user_id": userId,
        "after": after,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200 && responseData['code'] == 'SUCCESS') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', after);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      await DialogMaker.dialog(context, '변경 성공', '이메일이 변경됬습니다..');
    } else {
      DialogMaker.dialog(context, '변경 실패', '에러 코드: ${response.statusCode}');
    }
  }
}