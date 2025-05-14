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
  var name = 'jun';
  var movies = [];

  Movie? findMovie(int i){
    print("호출1");
    for(Movie m in movies){
      print("id: "+m.id.toString());
      if(m.id == i)return m;
    }
    print("호출2");
    return null;
  }

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

  changeName(){
    name = 'john';
    notifyListeners();
  }
}

