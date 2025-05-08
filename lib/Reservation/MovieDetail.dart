import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/Response/MovieRating.dart';
import '../Common/ApiService.dart';
import '../Response/Movie.dart';
import '../Common/navbar.dart';
import '../Common/ExpandableText.dart';
import 'DetailReservation.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

YoutubePlayerController? _youtubeController;

class MovieDetailPage extends StatefulWidget {
  final String title;
  const MovieDetailPage({super.key, required this.title});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  int? movieId;
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
  double averageRating = 3;

  bool isLoading = true;

  // 리뷰 관련
  double userRating = 0;
  bool containsSpoiler = false;
  final TextEditingController reviewController = TextEditingController();
  final List<Map<String, dynamic>> reviews = [];
  final Set<int> spoilerExpanded = {};
  int _visibleCount = 6;  // 🌟 한 번에 보여줄 리뷰 수

  @override
  void initState() {
    super.initState();
    initMovies();


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

    // 🌟 백엔드에서 데이터를 불러오는 코드 추가 예정
    _fetchReviews(); // 리뷰 데이터를 백엔드에서 불러오는 함수 호출

    // 초기 리뷰 샘플데이터
    reviews.addAll([
      {
        'rating': 4.5,
        'review': '정말 재미있었어요!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'spoiler': false,
      },
      {
        'rating': 3.0,
        'review': '결말이 예상밖이었어요. (스포일러)',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'spoiler': true,
      },
    ]);
  }

  Future<void> setAverageRating() async {
    final api = ApiService();
    if (movieId != null) {
      final params = {'movieId': movieId!};
      MovieRating result = await api.getRating("v1/review/rating", params);
      setState(() {
        averageRating = result.averageRating;
      });
    }
  }

  void _submitReview() {
    if (userRating == 0 || reviewController.text.trim().isEmpty) return;
    setState(() {
      reviews.add({
        'rating': userRating,
        'review': reviewController.text.trim(),
        'timestamp': DateTime.now(),
        'spoiler': containsSpoiler,
      });
      userRating = 0;
      reviewController.clear();
      containsSpoiler = false;

      // 🌟 새로운 리뷰를 백엔드로 전송하는 코드 추가 예정
      // 예를 들어, http.post('https://your-api.com/reviews', body: {...})를 사용하여
      // 새로운 리뷰를 백엔드에 저장할 수 있습니다.
    });

  }

  Future<void> initMovies() async {
    final api = ApiService();
    List<Movie> result = await api.searchMovieDetail("v1/movies/search", {"keyword": widget.title});

    if (result.isNotEmpty) {
      final movieData = result.first;
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
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  // 🌟 백엔드에서 리뷰 데이터를 불러오는 함수 (예시)
  Future<void> _fetchReviews() async {
    // 예시 코드: 실제 백엔드 API 호출 코드로 교체 필요
    // 예를 들어, http.get('https://your-api.com/reviews')를 사용하여 데이터를 가져옵니다.

    // 데이터를 받아오고 나서, state를 업데이트하여 UI에 반영합니다.
    setState(() {
      // 여기서는 샘플 데이터를 없애고, 실제 API 응답 데이터를 넣어주세요.
      // 예시로 빈 리스트로 초기화함. 실제로는 백엔드 데이터로 교체해야 합니다.
      reviews.clear();  // 이전 데이터 초기화
      reviews.addAll([
        // 아래에 백엔드에서 받은 데이터를 넣는 방식으로 수정
        // {
        //   'rating': fetchedData['rating'],
        //   'review': fetchedData['review'],
        //   'timestamp': DateTime.parse(fetchedData['timestamp']),
        // },
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
              // 영화 상세 정보
              ..._buildMovieDetail(),

              const SizedBox(height: 30),

              // 리뷰 작성 & 리스트
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
                      itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() => userRating = rating);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text('등록', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    CheckboxListTile(
                      title: const Text('스포일러가 포함되어 있어요'),
                      value: containsSpoiler,
                      onChanged: (value) =>
                          setState(() => containsSpoiler = value ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    const Text('리뷰 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        final displayText = isSpoiler && !isExpanded ? '' : review['review'];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                if (displayText.isNotEmpty) Text(displayText),
                                if (isSpoiler && !isExpanded)
                                  TextButton(
                                    onPressed: () => setState(() => spoilerExpanded.add(index)),
                                    child: const Text('스포일러 보기', style: TextStyle(color: Colors.red)),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
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
            const Text('등장인물 / 감독', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(  //감독 및 등장인물이 실제로 출력되는 부분인데 추후에 받는 데이터의 갯수에 따라 조절해야함 (함수 추가)
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

