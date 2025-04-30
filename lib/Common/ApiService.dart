import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;


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
}
