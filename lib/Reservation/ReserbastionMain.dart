import 'package:flutter/material.dart';
import 'package:movie/auth/SignupPage.dart';
import 'package:video_player/video_player.dart';
import '../Common/MovieCategoryChips.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String director;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.director
  });
}

class ReservationMain extends StatefulWidget {
  const ReservationMain({super.key});


  @override
  State<ReservationMain> createState() => _ReservationMainState();
}

class _ReservationMainState extends State<ReservationMain> {
  late VideoPlayerController _controller;

  String searchKeyword = ''; // 검색어 상태


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI가 추천하는 영화'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SearchModalWidget(
                          onSearch: (searchKeyword) {
                            setState(() {
                              searchKeyword = searchKeyword;
                            });
                          }
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ //AI 추천 포스터 출력
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg',
                      width: 220,
                      height: 330,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 영화 정보 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '미키 17 (15세)',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('2시간 17분', style: TextStyle(fontSize: 18)),
                        const Text('내 상영관 (건대입구)', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        const Text('감독: 봉준호', style: TextStyle(fontSize: 18)),
                        const Text('장르: 어드벤처, SF, 드라마', style: TextStyle(fontSize: 18)),
                        const Text('개봉: 2025.02.28', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        // 예매하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.redAccent),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('예매 하기'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //좌우 정렬
              children: [
                Text(
                  '상영중인 영화',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()), //이후 수정해야함
                      );
                    },
                  ),
                ),
              ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MovieCategoryChips(), // 여기에 삽입
              const SizedBox(height: 8),
              // 영화 목록 (GridView 등)
            ],
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
