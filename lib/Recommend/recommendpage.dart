import 'dart:convert';

import 'package:flutter/material.dart';
import '../Common/ApiService.dart';
import '../Common/Apiservicev3.dart';
import '../Common/MovieCategoryChips.dart';
import '../Response/Movie.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';
import '../Reservation/MovieDetail.dart';
import '../reserve/TheaterPage.dart';
import 'package:movie/Recommend/recommendmovie.dart';

import 'Maintab.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});


  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  String searchKeyword = ''; // 검색어 상태

  List<Movie> products = [];
  bool isLoading = true;

  Apiservicev3 apiServicev3 = new Apiservicev3();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final fetched = await apiServicev3.dailyMovie();

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
             // Maintab(),
              const MovieCategoryChips(), // 여기에 삽입
              const SizedBox(height: 8),
              // 영화 목록 (GridView 등)
            ],
          ),
          isLoading ? const Center( child: CircularProgressIndicator(strokeWidth: 4, color: Colors.redAccent,)) :
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
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 버튼을 눌렀을 때, 다른 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecommendMovie(), // 다른 페이지로 이동
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("AI 영화 추천"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
