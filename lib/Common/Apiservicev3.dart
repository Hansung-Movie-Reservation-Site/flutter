import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:movie/Response/Reviews.dart';
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
/*
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

  Future<Movie?> findmoviebyid(int movie_id) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.get(
        'v1/movies/search',
        queryParameters: {'keyword': movie_id},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        print("findmovie 성공");
        //if (data['errorCode'] == 'SUCCESS') {
        return Movie.fromJson(data);
        // }
        // return [];
      }
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return null;
    } catch (e) {
      print("기타 예외: $e");
      return null;
    }
    return null;
  }

  Future<List<Reviews>> getReviewAll() async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.get(
        'v1/review/getReviews',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        //if (data['errorCode'] == 'SUCCESS') {
        final List<dynamic> list = data;
        return list.map((item) => Reviews.fromJson(item)).toList();
        // }
        // return [];
      }
      return [];
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return [];
    } catch (e) {
      print("기타 예외: $e");
      return [];
    }
    return [];
  }
 */
}
