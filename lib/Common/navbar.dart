import 'package:flutter/material.dart';
import 'package:movie/mypage/Mypage_logout.dart';
import 'package:movie/Recommend/recommendpage.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 선택된 페이지 이름 추적 (선택 상태 표시용)
    String currentPage = ModalRoute.of(context)?.settings.name ?? '';

    const activeColor = Colors.blueAccent;
    const inactiveColor = Colors.grey;

    return Container(
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
            routeName: '', //이후 수정
            isActive: currentPage == '',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            label: '마이페이지',
            routeName: '/MyPage_Logout', //이후 수정
            isActive: currentPage == '/MyPage_Logout',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
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
