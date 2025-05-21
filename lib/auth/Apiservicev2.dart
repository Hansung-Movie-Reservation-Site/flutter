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

import '../Response/Movie.dart';

final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*', // 또는 application/json
      },
    )
);
//'https://hs-cinemagix.duckdns.org/api/'

class Apiservicev2 {
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,}) async {
    final cookieJar = CookieJar();
    Future<void> printCookies() async {
      final uri = Uri.parse('http://localhost:8080/api/');
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

  Future<Map<String, dynamic>?> aiRecommand(int user_id) async {
    try {
      print("1");
      var response = await dio.post(
        "v1/AIRecommand/synopsis",
        data: {"user_id": user_id},
      );
      print("2");
      if (response.statusCode == 200) {
        print('성공 에러코드: ${response.statusCode}');
        return response.data;
      } else {
        print('오류 발생: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      // 서비스 메서드에서
      if (e.response?.statusCode == 403) {
        throw DioException(requestOptions: e.requestOptions, response: e.response); // 또는 특정 커스텀 예외로 throw
      }
      print('예외 발생: $e');
      return null;
    }
  }

  Future<Movie?> findMovie(int movie_id) async {
    String id = movie_id.toString();
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.get(
        'v1/movies/searchById',
        queryParameters: {'id': movie_id},
      );

      if (response.statusCode == 200) {
        Movie data = Movie.fromJson(response.data);
        print("title: ${data.title}");
        return data;
      } else {
        print("에러 코드: ${response.statusCode} / 영화 로드 실패");
        return null;
      }
    } on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return null;
    } catch (e) {
      print("기타 예외: $e");
      return null;
    }
  }

}

