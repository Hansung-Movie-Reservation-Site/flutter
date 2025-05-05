import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'movie.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://43.200.184.143:8080/api/",
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    ),
  );

  /// 이메일 인증 코드 요청 (POST 요청)
  Future<String?> sendVerificationEmail(String url, Map<String, String> request) async {
    try {
      final response = await _dio.post(
        url, // baseUrl + /email/send
        data: request,
      );
      print(response);
      return "인증 코드가 이메일로 전송되었습니다.";
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message'] ?? "서버에 연결할 수 없습니다.";
      }
      return "알 수 없는 오류가 발생했습니다.";
    }
  }

  ///영화 정보 받아오기 API
  Future<List<Movie>> searchMovieDetail(String url, Map<String, String> request) async {
    try {
      final response = await _dio.get(url, queryParameters: request,);
      final decoded = response.data;

      List<Movie> movies = (decoded as List)
          .map((json) => Movie.fromJson(json as Map<String, dynamic>))
          .toList();
      return movies;
    } catch (e) {
      print("영화 정보를 받아오는 중 에러가 발생했습니다.");
      return [];
    }
  }

  Future<List<Movie>> dailyMovie(String url) async {
    try {
      final response = await _dio.get(url);
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
