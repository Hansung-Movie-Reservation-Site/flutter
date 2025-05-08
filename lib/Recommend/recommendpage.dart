import 'dart:convert';

import 'package:flutter/material.dart';
import '../Common/ApiService.dart';
import '../Common/MovieCategoryChips.dart';
import '../Common/movie.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import '../Reservation/MovieDetail.dart';
import '../reserve/TheaterPage.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});


  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  String searchKeyword = ''; // 검색어 상태

  List<Movie> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final api = ApiService();
    final fetched = await api.dailyMovie("v1/movies/daily");

    if (fetched != []) {
      print('받아온 영화 수: ${fetched.length}');
      setState(() {
        products = fetched;
        isLoading = false;
      });
    } else {
      print("fetchProducts 함수 동작 실패 / 빈 배열");
      setState(() {
        isLoading = false; // 로딩 실패
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영화 데이터를 불러올 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
        actions: [
          IconButton( // 검색 아이콘 관련
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
                      width: 160,
                      height: 240,
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('2시간 17분', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('감독: 봉준호', style: TextStyle(fontSize: 16)),
                        const Text('장르: 어드벤처, SF, 드라마', style: TextStyle(fontSize: 16)),
                        const Text('개봉: 2025.02.28', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),

                        // 예매하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TheaterPage()),
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
          isLoading ? const Center(child: CircularProgressIndicator()) :
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 20,
            childAspectRatio: 0.65,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: products.map((product) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.posterImage,
                          width: double.infinity,
                          height: 195, //이미지 크기
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MovieDetailPage(title: product.title),
                                  ),
                                );
                              },
                              child: Text(
                                product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
