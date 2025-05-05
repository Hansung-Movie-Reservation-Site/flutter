import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Common/ApiService.dart';
import '../Common/movie.dart';
import '../Common/navbar.dart';
import '../Common/ExpandableText.dart';
import 'DetailReservation.dart';

class MovieDetailPage extends StatefulWidget {
  final String title;
  const MovieDetailPage({super.key, required this.title});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  String movieName = '';
  String runTime = '';
  String Genre = '';
  String Mytheater = '없음';
  String StartDate = '';
  String Director = '';
  String ShortStory = '';
  String imageUrl = '';
  String cinema = '없음';
  String videoUrl = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initMovies();
  }

  Future<void> initMovies() async {
    final api = ApiService();
    List<Movie> result = await api.searchMovieDetail("v1/movies/search", {"keyword": widget.title});

    if (result.isNotEmpty) {
      setState(() {
        movie = result.first;
        movieName = movie!.title;
        runTime = "${movie!.runtime}분";
        Genre = movie!.genres;
        StartDate = movie!.releaseDate;
        Director = movie!.director;
        ShortStory = movie!.overview;
        imageUrl = movie!.posterImage;
        videoUrl = movie!.fullVideoLink;
        isLoading = false;
      });
    } else {
      print("영화의 데이터를 가져올 수 없습니다.");
      print("받아온 타이틀 ${widget.title}");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      )
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 200,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                        children: [
                          Text(
                            movieName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          const SizedBox(height: 8),
                          Text(runTime, style: const TextStyle(fontSize: 18)),
                          Text('내 영화관($Mytheater)', style: const TextStyle(fontSize: 18)),
                          Text('감독: $Director', style: const TextStyle(fontSize: 16)),
                          Text('장르: $Genre', style: const TextStyle(fontSize: 16)),
                          Text('개봉 날짜: $StartDate', style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailReservation(
                                      movieName: movieName,
                                      cinema: cinema,
                                      runTime: runTime,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: const Text(
                                '예매 하기',
                                style: TextStyle(color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding( // 예고편 동영상
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: videoUrl.isNotEmpty
                  ? SizedBox(
                height: 200,
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse(videoUrl)),
                ),
              )
                  : const SizedBox(
                height: 200,
                child: Center(child: Text("예고편을 불러오는 중입니다...")),
              ),
            ),

            const SizedBox(height: 30),

            Padding( // 더보기 기능 있는 텍스트 상자
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
              ExpandableText( // 더보기 기능 있는 텍스트 상자 함수
                text: ShortStory,
                maxLines: 3,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '등장인물 / 감독',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column( //감독 및 등장인물이 실제로 출력되는 부분인데 추후에 받는 데이터의 갯수에 따라 조절해야함 (함수 추가)
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(height: 10),
                                ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80, //이미지 크기
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  Director,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ]
                          )
                        ],
                      )
                    ]
                )
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }}
