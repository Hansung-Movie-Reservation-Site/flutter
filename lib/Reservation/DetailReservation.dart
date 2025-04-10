import 'package:flutter/material.dart';
import 'package:movie/Common/CinemaChips.dart';
import 'package:movie/Common/DateChips.dart';
import 'package:movie/auth/SignupPage.dart';
import '../Common/MovieCategoryChips.dart';
import '../Common/navbar.dart';
import '../Common/SearchModal.dart';

class DetailReservation extends StatefulWidget {
  final String movieName;
  final String cinema;
  final String runTime;

  const DetailReservation({
    super.key,
    required this.movieName,
    required this.cinema,
    required this.runTime,
  });


  @override
  State<DetailReservation> createState() => _ReservationMainState();
}

class _ReservationMainState extends State<DetailReservation> {

  final List<Map<String, dynamic>> dummy = [
    {
      "id": 1,
      "start": "10:00",
      "finish": "12:00",
      "availableSeats": 90,
      "roomId": 3,

    },
    {
      "id": 2,
      "start": "12:30",
      "finish": "14:30",
      "availableSeats": 110,
      "roomId": 3,
    },
    {
      "id": 3,
      "start": "15:00",
      "finish": "17:00",
      "availableSeats": 100,
      "roomId": 3,
    },
    {
      "id": 4,
      "start": "17:30",
      "finish": "19:30",
      "availableSeats": 120,
      "roomId": 3,
    },
    {
      "id": 5,
      "start": "20:00",
      "finish": "22:00",
      "availableSeats": 130,
      "roomId": 3,
    },
  ];

  late List<ScreeningTime> information = dummy.map((json) => ScreeningTime.fromJson(json)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영화부기'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[100],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ //AI 추천 포스터 출력
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://img.cgv.co.kr/Movie/Thumbnail/Poster/000089/89058/89058_320.jpg',
                      width: 150,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 영화 정보 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movieName,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.runTime, style: TextStyle(fontSize: 18)),
                        Text('내 상영관 (${widget.cinema})', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        // 극장변경 버튼
                        ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.redAccent),
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('극장변경'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateChips(),
              Text( // roomId가 1인 해당 영화의 모든 시간대를 가져오면 될듯?
                '상영관 1관',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              CinemaChips(information: information),
              Text(
                '상영관 2관',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              CinemaChips(information: information),
              const SizedBox(width: 8),
              // 영화 목록 (GridView 등)
            ],
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
