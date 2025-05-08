import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  // 리뷰 관련
  double userRating = 0;
  bool containsSpoiler = false;
  final TextEditingController reviewController = TextEditingController();
  final List<Map<String, dynamic>> reviews = [];
  final Set<int> spoilerExpanded = {};
  int _visibleCount = 6;

  @override
  void initState() {
    super.initState();
    initMovies();
    _fetchReviews();

    reviews.addAll([
      {
        'rating': 4.5,
        'review': '정말 재미있었어요!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'spoiler': false,
        'likes': 2,  // 좋아요 개수
        'likedByMe': false,  // 내가 좋아요 눌렀는지 여부
      },
      {
        'rating': 3.0,
        'review': '결말이 예상밖이었어요.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'spoiler': true,
        'likes': 5,
        'likedByMe': false,
      },
      {
        'rating': 1.0,
        'review': '굳이 찾아 볼 만큼은 아닌 듯',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'spoiler': false,
        'likes': 2,
        'likedByMe': false,
      },
      {
        'rating': 4.5,
        'review': '마지막에 범인 밝혀질 때 너무 놀랐다. 반전 있는 영화',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'spoiler': true,
        'likes': 0,
        'likedByMe': false,
      },
    ]);
  }

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r['rating'] as double).reduce((a, b) => a + b) / reviews.length;
  }

  void _submitReview() {
    if (userRating == 0 || reviewController.text.trim().isEmpty) return;
    setState(() {
      reviews.add({
        'rating': userRating,
        'review': reviewController.text.trim(),
        'timestamp': DateTime.now(),
        'spoiler': containsSpoiler,
        'likes': 0,
        'likedByMe': false,
      });
      userRating = 0;
      reviewController.clear();
      containsSpoiler = false;
    });
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
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchReviews() async {
    setState(() {
      reviews.clear();
      reviews.addAll([
        // 실제 API 데이터로 대체
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reversedReviews = List.from(reviews.reversed);
    final displayCount = _visibleCount.clamp(0, reversedReviews.length);

    return Scaffold(
      appBar: AppBar(title: const Text('영화부기')),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildMovieDetail(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('평균 별점: ${averageRating.toStringAsFixed(1)} / 5.0',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 32,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) => setState(() => userRating = rating),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: reviewController,
                            decoration: const InputDecoration(
                              labelText: '리뷰 작성',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _submitReview,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('등록', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: const Text('스포일러가 포함되어 있어요'),
                      value: containsSpoiler,
                      onChanged: (value) => setState(() => containsSpoiler = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    const Text('리뷰 목록',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (displayCount < reversedReviews.length)
                          ? displayCount + 1
                          : displayCount,
                      itemBuilder: (context, index) {
                        if (index == displayCount && displayCount < reversedReviews.length) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () => setState(() => _visibleCount += 5),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey.shade400),
                                ),
                              ),
                              child: const Text("더보기", style: TextStyle(fontSize: 16)),
                            ),
                          );
                        }

                        final review = reversedReviews[index];
                        final isSpoiler = review['spoiler'] == true;
                        final isExpanded = spoilerExpanded.contains(index);
                        final displayText = review['review'];

                        return GestureDetector(
                          onTap: () {
                            if (isSpoiler) {
                              setState(() {
                                if (isExpanded) {
                                  spoilerExpanded.remove(index);
                                } else {
                                  spoilerExpanded.add(index);
                                }
                              });
                            }
                          },
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 5),
                                      Text('${review['rating']}',
                                          style: const TextStyle(fontSize: 16)),
                                      const SizedBox(width: 10),
                                      if (isSpoiler)
                                        const Text(
                                          '⚠️ 스포일러가 포함된 리뷰입니다.',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (!isSpoiler || isExpanded)
                                              Text(displayText)
                                            else
                                              const Text(
                                                '터치하여 보기',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.thumb_up,
                                              color: review['likedByMe'] == true
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                review['likedByMe'] =
                                                !(review['likedByMe'] ?? false);
                                                if (review['likedByMe']) {
                                                  review['likes'] = (review['likes'] ?? 0) + 1;
                                                } else {
                                                  review['likes'] = (review['likes'] ?? 0) - 1;
                                                }
                                              });
                                            },
                                          ),
                                          Text('${review['likes'] ?? 0}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  List<Widget> _buildMovieDetail() {
    return [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl, width: 200, height: 300, fit: BoxFit.cover),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movieName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
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
                      child: const Text('예매 하기', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Padding(
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExpandableText(text: ShortStory, maxLines: 3),
      ),
      const SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('등장인물 / 감독',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    Text(Director, style: const TextStyle(fontSize: 18)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
