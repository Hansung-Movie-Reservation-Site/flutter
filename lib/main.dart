import 'package:flutter/material.dart';
import 'package:movie/providers/auth_provider.dart';
import 'package:movie/Recommend/recommendpage.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/mypage/ProfilePage.dart';
import 'package:movie/reserve/TheaterPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Common/notification.dart';
import 'Recommend/Abc.dart';
import 'Recommend/MainPage.dart';
import 'mypage/Mypage_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotification(); // 앱 실행 전 알림 초기화
  await logout();
  runApp(const MyApp());
}

logout() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
  await prefs.remove('user_id');
  await prefs.remove('email');
  await prefs.setBool('isLoggedIn', false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => MovieStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Mainpage(),
        routes: {
          '/recommendpage': (context) => Mainpage(),
          '/MyPage_Logout': (context) => MyPage_Logout(),
          '/MyPage_Login': (context) => MyPage_Login(),
          '/ProfilePage': (context) => ProfilePage(),
          '/Reserve': (context) => const TheaterPage(),
        },
      ),
    );
  }
}
