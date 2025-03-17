import 'package:flutter/material.dart';
import 'package:movie/auth/SignupPage.dart';
import 'package:video_player/video_player.dart';
import '../Common/MovieCategoryChips.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late VideoPlayerController _controller;

  final List<Product> products = [
    Product(
      name: '미키 17',
      price: 10.99,
      imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg',
    ),
    Product(
      name: '스트리밍',
      price: 8.99,
      imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89483/89483_320.jpg',
    ),
    Product(
      name: '백설공주',
      price: 12.50,
      imageUrl: 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000088/88630/88630_320.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', // 🐝 샘플 영상 URL
    )
      ..initialize().then((_) {
        setState(() {}); // 영상 초기화 후 빌드
        _controller.play(); // 자동 재생
        _controller.setLooping(true); // 반복 재생
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI가 추천하는 영화')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 250,
                color: Colors.black,
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : const Center(
                  child: CircularProgressIndicator(), // 로딩 중 표시
                ),
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
              const SizedBox(height: 12),
              // 영화 목록 (GridView 등)
            ],
          ),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: products.map((product) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl,
                          width: double.infinity,
                          height: 350, //이미지 크기
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
    );
  }
}
