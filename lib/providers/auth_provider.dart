import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Common/movie.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners(); // UI 업데이트
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners(); // UI 업데이트
  }
}


class MovieStore with ChangeNotifier {
  var movies = [];

  Future<void> getMovieData() async {
    final response = await http.get(Uri.parse('https://hs-cinemagix.duckdns.org/api/v1/movies/daily'));
    ///search/id
    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(utf8Body);
      final fetched = data.map((json) => Movie.fromJson(json)).toList();
      for (var movie in fetched) {
        print('getMovieData - 제목: ${movie.title}, 이미지: ${movie.posterImage}');
        movies.add(movie);
      }
    } else {
      print('에러 코드: ${response.statusCode}');
    }
  }
}

