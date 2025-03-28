import 'package:flutter/material.dart';
import 'package:movie/auth/SignupPage.dart';
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

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});


  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  String searchKeyword = ''; // 검색어 상태

  // 검색 필터링 함수
  List<Product> get filteredProducts {
    if (searchKeyword.isEmpty) return products;
    return products
        .where((p) => p.name.contains(searchKeyword))
        .toList();
  }

  //더미 데이터
  final List<Product> products = [
    Product(
        name: '미키 17',
        price: 10.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '스트리밍',
        price: 8.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89483/89483_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '백설공주',
        price: 12.50,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000088/88630/88630_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '승부',
        price: 10.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89485/89485_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '3일',
        price: 10.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89461/89461_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '퇴마록',
        price: 10.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89386/89386_320.jpg',
        director: '봉준호'
    ),
    Product(
        name: '플로우',
        price: 10.99,
        imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89450/89450_320.jpg',
        director: '봉준호'
    ),
  ];

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
                          product.imageUrl,
                          width: double.infinity,
                          height: 195, //이미지 크기
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //좌우 정렬
                          children: [
                            Text(
                              product.name,
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
                      )
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
