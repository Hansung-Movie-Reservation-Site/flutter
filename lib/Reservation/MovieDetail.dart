import 'package:flutter/material.dart';
import '../Common/navbar.dart';
import '../Common/ExpandableText.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  //나중에 객체로 받을 예정
  String MovieName = '미키 17'; //영화 이름
  String Runtime = '상영시간'; ///상영시간(이건 임시 값 추후에 정해야함)
  String Genre = '장르'; //장르
  String Mytheater = '건대입구'; //장르
  String StartDate = '개봉날짜'; ///개봉날짜(이건 임시 값 추후에 정해야함)
  String Director = '감독명';
  String ShortStory = '줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리줄거리'; //줄거리
  String imageUrl = 'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
      ),
      body:
        Column(
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
                            MovieName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          Text( /// 상영 시간
                            Runtime,
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
                                // 버튼 클릭 시 실행할 코드
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
            Text( /// 개봉 날짜
              '이곳에 예고편 동영상 삽입 예정',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ExpandableText( // 더보기 기능 있는 텍스트 상자
                text: ShortStory,
                maxLines: 3,
            ),
            const SizedBox(height: 30),
            Container(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '등장인물 / 감독',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 20,
                        height: 30, //이미지 크기
                        fit: BoxFit.cover,
                      ),
                    ),
                    ]
              )
            )

          ],

        )
    );
  }}
