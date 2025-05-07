import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double userRating = 0;
  final TextEditingController reviewController = TextEditingController();
  final List<Map<String, dynamic>> reviews = [];

  int _visibleCount = 6; // 🌟 한 번에 보여줄 리뷰 수

  @override
  void initState() {
    super.initState();

    // 🌟 백엔드에서 데이터를 불러오는 코드 추가 예정
    _fetchReviews(); // 리뷰 데이터를 백엔드에서 불러오는 함수 호출
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
      });
      userRating = 0;
      reviewController.clear();

      // 🌟 새로운 리뷰를 백엔드로 전송하는 코드 추가 예정
      // 예를 들어, http.post('https://your-api.com/reviews', body: {...})를 사용하여
      // 새로운 리뷰를 백엔드에 저장할 수 있습니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    final reversedReviews = List.from(reviews.reversed);
    final displayCount = _visibleCount.clamp(0, reversedReviews.length);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '영화 리뷰',
          style: TextStyle(fontSize: 27, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '평균 별점: ${averageRating.toStringAsFixed(1)} / 5.0',
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
            const SizedBox(height: 20),
            const Divider(),
            const Text('리뷰 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: reviews.isEmpty
                  ? const Center(child: Text('아직 리뷰가 없습니다.'))
                  : ListView.builder(
                itemCount: (displayCount < reversedReviews.length)
                    ? displayCount + 1
                    : displayCount,
                itemBuilder: (context, index) {
                  if (index == displayCount && displayCount < reversedReviews.length) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _visibleCount += 5; // 5개씩 추가 로드
                          });
                        },
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
                  final isSample = reviews.indexOf(review) < 2; // 앞의 2개는 샘플로 간주

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: Text(review['review']),
                      subtitle: Text('별점: ${review['rating']} ${isSample ? '' : ''}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
