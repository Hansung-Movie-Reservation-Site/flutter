import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie/Common/Apiservicev3.dart';
import 'package:movie/Recommend/Maintab.dart';
import 'package:movie/Recommend/recommendmovie.dart';
import 'package:movie/Response/Airecommand.dart';
import 'package:movie/Response/Reviews.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Common/MovieCategoryChips.dart';
import '../Common/SearchModal.dart';
import '../Common/navbar.dart';
import '../Reservation/MovieDetail.dart';
import '../Response/Movie.dart';
import '../Response/RecommandMovie.dart';
import '../auth/Apiservicev2.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _currentIndex = 1;

  void _changeIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  Timer? _timer;
  final Apiservicev2 apiservicev2 = Apiservicev2();
  final Apiservicev3 apiservicev3 = Apiservicev3();
  int user_id = -1;
  List<Recommendmovie> result = [];
  List<Reviews> reviewresult = [];
  List<Movie> products = [];

  Future<void> fetchProducts() async {
    final fetched = await apiservicev3.dailyMovie();
    if (fetched.isNotEmpty) {
      setState(() {
        products = fetched;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('영화 데이터를 불러올 수 없습니다.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      int nextIndex = _currentIndex + 1;
      if (nextIndex > 5) nextIndex = 5;
      _changeIndex(nextIndex);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        user_id = prefs.getInt("user_id")!;
      } catch (e) {
        print("error userid");
      }

      reviewresult = await apiservicev2.getReviewAll();
      result = await apiservicev2.getRecommandMovies(user_id);
      fetchProducts();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Center(child: Text('영화부기')),
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
                      child: SearchModalWidget(onSearch: (searchKeyword) {}),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            const TextSpan(text: '당신의 '),
                            TextSpan(text: '인생영화', style: const TextStyle(color: Colors.redAccent)),
                            const TextSpan(text: '를 찾아보세요'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("당신의 리뷰를 분석하여 영화를 추천해드립니다.", style: TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      const Text("나의 추천 목록", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      result.isEmpty
                          ? (_currentIndex == 5
                          ? const Center(child: Text("로그인하고 AI에게 추천을 받으세요."))
                          : const Center(child: CircularProgressIndicator()))
                          : _movieRecommendationSlider(result),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendMovie()));
                          },
                          child: const Text("AI 추천받기", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                            const TextSpan(text: '다른 사람과 '),
                            TextSpan(text: '영화경험', style: const TextStyle(color: Colors.redAccent)),
                            const TextSpan(text: '을 공유해보세요'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      reviewresult.isEmpty
                          ? (_currentIndex == 5
                          ? const Center(child: Text("리뷰 목록을 불러오는데 실패했습니다."))
                          : const Center(child: CircularProgressIndicator()))
                          : _movieReviewsSlider(reviewresult),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text("상영 중인 영화를 확인해보세요", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center),
                ),
              ),
              const MovieCategoryChips(),
              products.isEmpty
                  ? (_currentIndex == 5
                  ? const Center(child: Text("상영 데이터를 불러오는데 실패했습니다."))
                  : const Center(child: CircularProgressIndicator()))
                  : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2 / 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: products.map((product) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailPage(title: product.title),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,  // 가로 꽉 채우기
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: AspectRatio(
                                  aspectRatio: 2 / 2.6,
                                  child: Image.network(
                                    product.posterImage,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  product.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

Widget _movieRecommendationSlider(List<Recommendmovie> result) {
  return SizedBox(
    height: 220,
    child: PageView.builder(
      itemCount: result.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        final item = result[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(item.posterImage, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.6),
                    child: Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _movieReviewsSlider(List<Reviews> reviewresult) {
  return SizedBox(
    height: 130,
    child: PageView.builder(
      itemCount: reviewresult.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        final item = reviewresult[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            color: Colors.grey[200],
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                  child: Image.network(
                    item.poster,
                    width: 100,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('작성자: ${item.user}', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(item.rate.toString(), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            item.review,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}