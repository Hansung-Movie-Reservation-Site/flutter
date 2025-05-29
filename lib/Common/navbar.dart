import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/Recommend/recommendpage.dart';
import 'package:movie/Reservation/ReservastionMain.dart';

import '../auth/AuthService.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String myPageRoute = '/MyPage_Logout'; // 기본값

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 로그인 여부 확인 후 경로 변경
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      myPageRoute = isLoggedIn ? '/MyPage_Login' : '/MyPage_Logout';
    });
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 페이지 이름 추적 (선택 상태 표시용)
    String currentPage = ModalRoute.of(context)?.settings.name ?? '';

    const activeColor = Colors.blueAccent;
    const inactiveColor = Colors.grey;

    return SafeArea(
      // minimum: const EdgeInsets.only(bottom: 8), // 추가 여백 필요하면
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            _buildNavItem(
              context,
              icon: Icons.search,
              label: '영화 추천',
              routeName: '/recommendpage',
              isActive: currentPage == '/recommendpage',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            _buildNavItem(
              context,
              icon: Icons.map_outlined,
              label: '예매',
              routeName: '/Reserve', // 이후 수정 필요
              isActive: currentPage == '/Reserve',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: '마이페이지',
              routeName: myPageRoute,
              isActive: currentPage == myPageRoute,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String routeName,
        required bool isActive,
        required Color activeColor,
        required Color inactiveColor,
      }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != routeName) {
            Navigator.pushNamed(context, routeName);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : inactiveColor,
              size: 28,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
