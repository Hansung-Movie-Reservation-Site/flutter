import 'package:dio/dio.dart';
import 'package:movie/Response/MovieReview.dart';
import 'package:movie/Response/ReviewLike.dart';
import '../Response/Movie.dart';
import '../Response/MovieRating.dart';
import '../Response/Region.dart';
import '../Response/Screening.dart';
import '../Response/Seat.dart';
import '../Response/Spot.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://hs-cinemagix.duckdns.org/api/",
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

  // 메인페이지 영화 목록 불러오는 함수
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

  // 리뷰불러오기
  Future<List<Review>> getReview(String url, Map<String, int> request) async {
    try {
      final response = await _dio.get(url, queryParameters: request,);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        final review = data.map((json) => Review.fromJson(json)).toList();
        print("ApiService / 받아온 리뷰 ${review.length}");
        return review;
      } else {
        print('에러 코드: ${response.statusCode} / 리뷰를 불러올 수 없습니다.');
        return [];
      }
    } catch (e, stacktrace) {
      print("리뷰 API 예외 발생");
      print("예외 객체: $e");
      print("스택트레이스: $stacktrace");
      return [];
    }
  }

  // 별점
  Future<MovieRating> getRating(String url, Map<String, int> request) async {
    try {
      final response = await _dio.get(url, queryParameters: request);
      if (response.statusCode == 200) {
        return MovieRating.fromJson(response.data);
      } else {
        print("에러 코드: ${response.statusCode} / 리뷰를 불러올 수 없습니다.");
        throw Exception("리뷰 요청 실패");
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? "서버에 연결할 수 없습니다. / 리뷰");
      }
      throw Exception("알 수 없는 오류 발생");
    }
  }

  //리뷰 저장
  Future<String> postReview(String url, Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(url, data: request);
      if (response.statusCode == 200) {
        return "리뷰가 저장되었습니다.";
      } else {
        print("에러 코드: ${response.statusCode} / 리뷰 저장 실패");
        throw Exception("리뷰 저장 실패");
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message'] ?? "서버 오류 (리뷰 저장)";
      }
      return "알 수 없는 오류 발생";
    }
  }

  //리뷰 좋아요 개수 불러오기
  Future<ReviewLike> getLikeCount(String url, Map<String, int> request) async {
    try {
      final response = await _dio.get(url, queryParameters: request);
      if (response.statusCode == 200) {
        //print("좋아요 로드 성공 / ApiService");
        return ReviewLike.fromJson(response.data);
      } else {
        print("에러 코드: ${response.statusCode} / 좋아요 로드");
        throw Exception("좋아요 로드 실패");
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message'] ?? "서버 오류 (좋아요 로드)";
      }
      throw Exception("알 수 없는 오류 발생 / 좋아요 로드");
    }
  }

  //좋아요 누르기
  Future<void> setLike(String url, Map<String, dynamic> request) async {
    try {
      final response = await _dio.post(url, queryParameters: request);
      if (response.statusCode == 200) {
        print("좋아요 성공 / ApiService");
      } else {
        print("에러 코드: ${response.statusCode} / 좋아요 실패");
        throw Exception("좋아요 저장 실패");
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.data?['message'] ?? "서버 오류 (좋아요 클릭)";
      }
      print("알 수 없는 에러 발생 / ApiService");
    }
  }

  Future<List<Region>> fetchRegions() async {
    final response = await _dio.get("v1/regions/getAll");
    return (response.data as List).map((r) => Region.fromJson(r)).toList();
  }

  Future<List<Spot>> fetchSpots() async {
    final response = await _dio.get("v1/spots/getAll");
    return (response.data as List).map((r) => Spot.fromJson(r)).toList();
  }

  Future<List<Screening>> fetchScreenings(String spotName, String date) async {
    try {
      final response = await _dio.get("/v1/screening", queryParameters: {
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
      final response = await _dio.get("/v1/screening/$screeningId/seats");

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

}
