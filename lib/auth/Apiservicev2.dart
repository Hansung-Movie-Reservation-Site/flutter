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

import '../Response/Airecommand.dart';
import '../Response/Movie.dart';
import '../Response/MyTheater.dart';
import '../Response/RecommandMovie.dart';
import '../Response/Region.dart';
import '../Response/Reviews.dart';
import '../Response/Screening.dart';
import '../Response/Seat.dart';
import '../Response/Spot.dart';
import '../providers/auth_provider.dart';

final dio = Dio(
    BaseOptions(
      baseUrl: 'https://hs-cinemagix.duckdns.org/api/',
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
      final cookies = await cookieJar.loadForRequest((Uri.parse(dio.options.baseUrl)));
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

        // context 없이 직접 Provider에 저장
        //authProvider.setList(myTheatherList);

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
    } catch (e, s) {
      if(e is DioException)print(e.response?.statusCode);
      print('예외 이유: $s');
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
      final response = await dio.get('v1/movies/searchById?id=$id');

      // final response = await dio.get(
      //   'v1/AIRecommand/recommended',
      //   queryParameters: {'id': movie_id},
      // );

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
      print("Dio 예외 / 디테일 페이지: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return null;
    } catch (e) {
      print("기타 예외: $e");
      return null;
    }
  }

  Future<List<Recommendmovie>> getRecommandMovies(int user_id) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.get(
        'v1/AIRecommand/recommended',
        queryParameters: {'userId': user_id},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        //if (data['errorCode'] == 'SUCCESS') {
          final List<dynamic> list = data;
          return list.map((item) => Recommendmovie.fromJson(item)).toList();
       // }
       // return [];
    }
      return [];
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 403){
      }
      print("Dio 예외 / 영화 추천: ${e.message}");
      print("응답 본문: ${e.response?.data}");
      return [];
    } catch (e) {
      print("기타 예외: $e");
      return [];
    }
    return [];
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

  Future<List<Region>> fetchRegions() async {
    final response = await dio.get("v1/regions/getAll");
    return (response.data as List).map((r) => Region.fromJson(r)).toList();
  }

  Future<List<Spot>> fetchSpots() async {
    final response = await dio.get("v1/spots/getAll");
    return (response.data as List).map((r) => Spot.fromJson(r)).toList();
  }

  Future<List<Screening>> fetchScreenings(String spotName, String date) async {
    try {
      final response = await dio.get("/v1/screening", queryParameters: {
        "spotName": spotName,
        "date": date,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Screening.fromJson(json)).toList();
      } else {
        throw Exception("상영 정보를 불러오지 못했습니다. 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchScreenings 예외: $e");
      rethrow;
    }
  }

  Future<List<Seat>> fetchSeats(int screeningId) async {
    try {
      final response = await dio.get("/v1/screening/$screeningId/seats");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Seat.fromJson(json)).toList();
      } else {
        print("좌석 불러오기 실패 / 코드: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("좌석 API 예외: $e");
      return [];
    }
  }

  Future<int?> makeOrderId(Map<String, dynamic> request) async {
    try {
      final response = await dio.post('v1/orders', data: request);
      if (response.statusCode == 200) {
        final data = response.data;
        final int orderId = data['id'];
        print("주문 id: $orderId");
        return orderId;
      } else {
        print('API 호출 실패 / 주문 정보 생성 api: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('예외 발생 / 주문 정보 생성 api: $e');
      return null;
    }
  }

  Future<String?> getPaymentUrl(Map<String, dynamic> request) async {
    try {
      final response = await dio.post('v1/payment/requestMobileWeb', data: request);
      if (response.statusCode == 200) {
        final data = response.data;
        final String? paymentUrl = data;
        return paymentUrl;
      } else {
        print('API 호출 실패 / 결제 링크: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('예외 발생 / 결제 링크: $e');
      return null;
    }
  }

  Future<List<MyTheater>> getMyTheater(int user_id) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.post(
        'v1/detail/retrieve/myTheater',
        queryParameters: {'user_id': user_id},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if(data == null) return [];

        //if (data['errorCode'] == 'SUCCESS') {
        final List<dynamic> rawList = data['myTheaterList'];
        for(int i=0; i< rawList.length;i++){
          print(rawList[i]);
        }
        return rawList.map((e) => MyTheater.fromJson(e)).toList();
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
  }

  Future<List<MyTheater>> setMyTheater(int user_id, List<int> mySpotList) async {
    try {
      //final response = await dio.get('v1/movies/searchById?id=$id');

      final response = await dio.post(
        'v1/detail/update/myTheater',
        queryParameters: {'user_id': user_id, 'mySpotList': mySpotList},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if(data == null) return [];

        //if (data['errorCode'] == 'SUCCESS') {
        final List<dynamic> rawList = data['myTheaterList'];
        for(int i=0; i< rawList.length;i++){
          print(rawList[i]);
        }
        return rawList.map((e) => MyTheater.fromJson(e)).toList();
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
  }
}

