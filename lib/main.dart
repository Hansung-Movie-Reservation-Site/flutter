import 'package:flutter/material.dart';
import 'package:movie/providers/auth_provider.dart';
import 'package:movie/Recommend/recommendpage.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/mypage/ProfilePage.dart';
import 'package:movie/reserve/TheaterPage.dart';
import 'package:provider/provider.dart';
import 'Recommend/Abc.dart';
import 'Recommend/MainPage.dart';
import 'mypage/Mypage_login.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
    ChangeNotifierProvider(
      create: (c) => MovieStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListPage(),

        routes: {
          '/recommendpage': (context) => ProductListPage(),
          '/MyPage_Logout': (context) => MyPage_Logout(),
          '/MyPage_Login': (context) => MyPage_Login(),
          '/ProfilePage': (context) => ProfilePage(),
          //'/Reserve': (context) => const TheaterPage(),
          '/Reserve': (context) => Mainpage(),
        },
      )
    );
  }
}
