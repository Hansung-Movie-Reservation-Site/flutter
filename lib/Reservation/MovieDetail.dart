import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/Response/MovieRating.dart';
import 'package:movie/Response/MovieReview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Common/ApiService.dart';
import '../Response/Movie.dart';
import '../Common/navbar.dart';
import '../Common/ExpandableText.dart';
import '../auth/Apiservicev2.dart';
import 'DetailReservation.dart';

YoutubePlayerController? _youtubeController;

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  int? movieId;
  int? userId;
  String? myUsername;
  String movieName = '';
  String runTime = '';
  String Genre = '';
  String Mytheater = '건대입구';
  String StartDate = '';
  String Director = '';
  String ShortStory = '';
  String imageUrl = '';
  String cinema = '없음';
  String videoUrl = '';
  double averageRating = 0;

  bool isLoading = true;

  // 리뷰 관련
  double userRating = 3;
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

    if (videoUrl.isNotEmpty && YoutubePlayer.convertUrlToId(videoUrl) != null) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl)!;

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

  }

  //평균 별점
  Future<void> setAverageRating() async {
    final api = Apiservicev2();
    if (movieId != null) {
      final params = {'movieId': movieId!};
      MovieRating result = await api.getRating("v1/review/rating", params);
      setState(() {
        averageRating = result.averageRating;
      });
    }
  }

  //리뷰 작성 완료
  void _submitReview() async {
    if (userRating == 0 || reviewController.text.trim().isEmpty) return;
    final api = Apiservicev2();
    final requestData = {
      "rating": userRating,
      "review": reviewController.text.trim(),
      "spoiler": containsSpoiler,
      "userId": userId,
      "movieId": movieId,
    };
    final result = await api.postReview("v1/review/reviews", requestData);
    await _fetchReviews();
  }

  void clickLike(int reviewId) async {
    final api = Apiservicev2();
    final params = {
      "userId": userId,
      "reviewId": reviewId,
    };
    final result = await api.setLike("v1/review/likeToggle", params);
    await _fetchReviews();
  }

  //영화 데이터 불러오기 및 별점과 리뷰 불러오기 실행
  Future<void> initMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    myUsername = prefs.getString('username');
    final api2 = Apiservicev2();
    Movie? movieData = await api2.findMovie(widget.movieId);

    if (movieData != null) {
      final videoId = YoutubePlayer.convertUrlToId(movieData.fullVideoLink ?? "");

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }

      setState(() {
        movie = movieData;
        movieId = movieData.id;
        movieName = movieData.title;
        runTime = "${movieData.runtime}분";
        Genre = movieData.genres;
        StartDate = movieData.releaseDate;
        Director = movieData.director;
        ShortStory = movieData.overview;
        imageUrl = movieData.posterImage;
        videoUrl = movieData.fullVideoLink;
        isLoading = false;
      });
      await setAverageRating();
      await _fetchReviews();

    } else {
      setState(() => isLoading = false);
    }
  }



  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  //리뷰 불러오기 (실행은 initMovies에서)
  Future<void> _fetchReviews() async {
    final api = Apiservicev2();
    List<Review> result = await api.getReview("v1/review/reviewWithLikes", {"movieId" : movieId!, "userId" : userId!});
    print("불러온 리뷰 개수: ${result.length}");
    setState(() {
      reviews.clear();  // 이전 데이터 초기화
      reviews.addAll(result.map((review) => {
        "reviewId": review.id,
        "username": review.username,
        "rating": review.rating,
        "review": review.review,
        "spoiler": review.spoiler,
        "timestamp": review.date,
        "likes": review.likeCount,
        "likedByMe": review.liked,
      }));
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
                    Text(
                      '평균 별점: $averageRating / 5.0',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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

                        bool isMyReview = false;
                        if (userId != null) {
                          if (review['username'] == myUsername) {
                            isMyReview = true;
                          }
                        }

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
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        review['username'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        review['timestamp'].toString(),
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      Spacer(), // 이 부분이 오른쪽 정렬의 핵심!
                                      if (review['username'] == myUsername)
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.redAccent, size: 22),
                                          onPressed: () async {
                                            final confirm = await showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text('리뷰 삭제'),
                                                content: Text('정말로 리뷰를 삭제하시겠습니까?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(ctx).pop(false),
                                                    child: Text('취소'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(ctx).pop(true),
                                                    child: Text('삭제'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              final api = Apiservicev2();
                                              final result = await api.deleteReview(
                                                review['reviewId'],
                                                userId!,
                                              );
                                              if (result) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('리뷰가 삭제되었습니다.')),
                                                );
                                                await _fetchReviews();
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('리뷰 삭제 실패')),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 5),
                                      Text(
                                        review['rating'].toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      if (isSpoiler && !isExpanded) ...[
                                        const SizedBox(width: 10),
                                        const Text(
                                          '⚠️ 스포일러가 포함된 리뷰입니다.',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
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
                                              color: review['likedByMe'] == true ? Colors.red : Colors.grey,
                                            ),
                                            onPressed: () {
                                              clickLike(review['reviewId']);
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

                        Navigator.pushNamed(context, '/Reserve');
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
        child: (videoUrl.isNotEmpty &&
            _youtubeController != null &&
            YoutubePlayer.convertUrlToId(videoUrl) != null)
            ? YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          width: double.infinity,
          aspectRatio: 16 / 9,
        )
            : const SizedBox(
          height: 200,
          child: Center(child: Text("예고편이 제공되지 않는 영화입니다.")),
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
