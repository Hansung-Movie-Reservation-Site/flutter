
import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
import '../providers/auth_provider.dart';
import 'Abc.dart';

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
  final Apiservicev2 apiservicev2 = new Apiservicev2();
  final Apiservicev3 apiservicev3 = new Apiservicev3();
  int user_id = -1;
  List<Recommendmovie> result = [];
  List<Reviews> reviewresult = [];

  List<Movie> products = [];

  Apiservicev3 apiServicev3 = new Apiservicev3();

  Future<void> fetchProducts() async {
    final fetched = await apiServicev3.dailyMovie();

    if (fetched != []) {
      print('받아온 영화 수: ${fetched.length}');
      setState(() {
        products = fetched;
      });
    } else {
      print("fetchProducts 함수 동작 실패 / 빈 배열");
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
        try{
          user_id = prefs.getInt("user_id")!;
          print("mainPage의 user_id: "+ user_id.toString());
        }
        catch(e){
          print("error userid");
        }

        reviewresult = await apiservicev2.getReviewAll();
        result = await  apiservicev2.getRecommandMovies(user_id!);
        print("result 요청 완.");
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
      body:
      Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 추천 목록
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text("# 당신의 ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("인생영화", style: TextStyle(fontSize: 28, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    Text("를 찾아보세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("당신의 리뷰를 분석하여 영화를 추천해드립니다.", style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 5),
                child: Text("나의 추천 목록", style: TextStyle(fontSize: 18)),
              ),
              result.isEmpty
                  ?
              _currentIndex == 5 ? Text("로그인하고 AI에게 추천을 받으세요.") : Center( child: CircularProgressIndicator(strokeWidth: 4, color: Colors.redAccent,))
                  : Container(
                margin: EdgeInsets.all(5),
                  child: _movieRecommendationSlider(result)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendMovie()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    child: Text("AI 추천받기", style: TextStyle(fontSize: 27)),
                  ),
                ),
              ),
              // 2. 리뷰 목록
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 5),
                child: Row(
                  children: [
                    Text("# 다른 사람과 ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    Text("영화경험을 ", style: TextStyle(fontSize: 28, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    Text("공유해보세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 20),
                child: Text("당신의 리뷰를 분석하여 영화를 추천해드립니다.", style: TextStyle(fontSize: 20)),
              ),
              reviewresult.isEmpty
                  ?
              _currentIndex == 5 ? Text("리뷰목록을 불러오는데 실패했습니다.") : Center( child: CircularProgressIndicator(strokeWidth: 4, color: Colors.redAccent,))
                  : _movieReviewsSlider(reviewresult),
              // 3. 상영데이터 목록
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("# 상영 중인 영화를 확인 해보세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    const MovieCategoryChips(), // 여기에 삽입
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              products.isEmpty
                  ?
              _currentIndex == 5 ? Text("상영데이터를 불러오는데 실패했습니다.") : Center( child: CircularProgressIndicator(strokeWidth: 4, color: Colors.redAccent,))
                  :
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
        )
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

// 먼저 이 예제를 넣을 위치를 정확히 알기 위해 _yourWidget() 형태로 만들어드립니다.

Widget _movieRecommendationSlider(List<Recommendmovie> result) {
  return SizedBox(
    height: 210, // 고정 높이
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
                Container(color: Colors.black12), // 배경 대체
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        result[index].posterImage,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "제목: ${result[index].title}",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.reason,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // 여기서 몇 줄까지 보일지 조절 가능
                      ),
                    ],
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
    height: 130, // 이미지 포함 높이
    child: PageView.builder(
      itemCount: reviewresult.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        final item = reviewresult[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // 포스터 이미지
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  child: Image.network(
                    item.poster,
                    width: 100,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
                  ),
                ),
                // 리뷰 정보
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '작성자: ${item.user}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              item.rate.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            item.review,
                            maxLines: 3,
                            overflow: TextOverflow.visible,
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

