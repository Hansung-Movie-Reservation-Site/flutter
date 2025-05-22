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
//로그인 여부 안따지는 api 통신 모음.
class Apiservicev3{
  final dio = Dio(
      BaseOptions(
        baseUrl: 'https://hs-cinemagix.duckdns.org/api/',
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*', // 또는 application/json
        },
      )
  );

  Future<List<Movie>> dailyMovie() async {
    try {
      final response = await dio.get("v1/movies/daily");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        final fetched = data.map((json) => Movie.fromJson(json)).toList();
        return fetched;
      } else {
        print('에러 코드: ${response.statusCode} / 영화 데이터를 불러올 수 없습니다.');
        return [];
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message'] ?? "서버에 연결할 수 없습니다.";
      }
      return [];
    }
  }
}