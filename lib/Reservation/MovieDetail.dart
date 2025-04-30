import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Common/navbar.dart';
import '../Common/ExpandableText.dart';
import 'DetailReservation.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  //나중에 객체로 받을 예정
  String movieName = '미키 17'; //영화 이름
  String runTime = '상영시간'; ///상영시간(이건 임시 값 추후에 정해야함)
  String Genre = '장르'; //장르
  String Mytheater = '건대입구'; //장르
  String StartDate = '개봉날짜'; ///개봉날짜(이건 임시 값 추후에 정해야함)
  String Director = '감독명';
  String ShortStory = '줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리'; //줄거리
  String imageUrl = 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg';
  String cinema = '건대입구';

  ///리뷰 페이지 여기에 넣을거임 추가해야함
  ///

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0, //그림자 값
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 200,
                        height: 300, //이미지 크기
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, //좌우 정렬
                        children: [
                          Text( /// 영화 제목
                            movieName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          Text( /// 상영 시간
                            runTime,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text( /// 내 영화관
                            '내 영화관($Mytheater)',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text( /// 감독
                            '감독: $Director',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text( /// 장르
                            '장르: $Genre',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text( /// 개봉 날짜
                            '개봉 날짜: $StartDate',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Align( /// 예매 버튼
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DetailReservation(
                                          movieName: movieName,
                                          cinema: cinema,
                                          runTime: runTime)));
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.grey), // 테두리 색상
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // 둥근 테두리
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 안쪽 여백
                                ),
                                child: Text(
                                  '예매 하기',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                          ),
                        ]
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding( // 예고편 동영상
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
              SizedBox(
                height: 200,
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse('https://www.youtube.com/embed/MFXWhpcuIg4')),
                ),
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
