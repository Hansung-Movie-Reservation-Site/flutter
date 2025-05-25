import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/DialogMaker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

final dio = Dio(BaseOptions(baseUrl: 'https://hs-cinemagix.duckdns.org/api/'));

class LoginFeatures {
  Future<void> login({
required BuildContext context,
required String email,
required String password,
}) async {

  final cookieJar = CookieJar();
  Future<void> printCookies() async {
    final uri = Uri.parse('https://hs-cinemagix.duckdns.org');
    final cookies = await cookieJar.loadForRequest(uri);
    print('저장된 쿠키 리스트:');
    for (var cookie in cookies) {
      print('${cookie.name} = ${cookie.value}');
    }
  }

try {
    dio.interceptors.add(CookieManager(cookieJar));

    final response = await dio.post('v1/user/login',
      data: {
      'email': email,
      'password': password,
    },
    );
    printCookies();

    if (response.statusCode == 200) {
      final responseData = response.data;
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
      await DialogMaker.dialog(context, '로그인 실패', '에러 코드: ${response.statusCode}');
    }
  } catch (e) {
    await DialogMaker.dialog(context, '로그인 실패', '오류가 발생했습니다.');
  }
}
}

