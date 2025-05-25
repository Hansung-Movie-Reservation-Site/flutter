import 'package:flutter/material.dart';

import '../Common/ApiService.dart';
import '../Response/Seat.dart';

class SeatSelectionUI extends StatefulWidget {
  final String movieTitle;
  final String theater;
  final String time;
  final DateTime date;
  final int generalCount;
  final int youthCount;
  final int screeningId;

  const SeatSelectionUI({
    super.key,
    required this.movieTitle,
    required this.theater,
    required this.time,
    required this.date,
    required this.generalCount,
    required this.youthCount,
    required this.screeningId,
  });

  @override
  State<SeatSelectionUI> createState() => _SeatSelectionUIState();
}

class _SeatSelectionUIState extends State<SeatSelectionUI> {
  final List<String> selectedSeats = [];
  List<Seat> seats = [];

  @override
  void initState() {
    super.initState();
    loadSeats();
  }


  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

  final int leftSeats = 2;
  final int centerSeats = 5;
  final int rightSeats = 2;
  final int totalColumns = 2 + 1 + 5 + 1 + 2; // 좌석 + 통로

  int get totalAllowed => widget.generalCount + widget.youthCount;
  int get totalPrice => (widget.generalCount * 13000) + (widget.youthCount * 10000);

  Future<void> loadSeats() async {
    final api = ApiService();
    final result = await api.fetchSeats(widget.screeningId);
    setState(() {
      seats = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('좌석 선택'),
        centerTitle: true,
        backgroundColor: Colors.red.shade800,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // 🎥 스크린
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade300,
              ),
              alignment: Alignment.center,
              child: const Text(
                'SCREEN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🎖 범례 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _seatLegendBox(Colors.black, '선택 가능'),
                const SizedBox(width: 10),
                _seatLegendBox(Colors.red, '선택됨'),
                const SizedBox(width: 10),
                _seatLegendBox(Colors.grey.shade600, '예약됨'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🎫 좌석 배치
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: rows.length * totalColumns,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: totalColumns,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.9, // 📐 좌석 비율 약간 높여서 크기 증가
                ),
                itemBuilder: (context, index) {
                  final rowIdx = index ~/ totalColumns;
                  final col = index % totalColumns;
                  final row = rows[rowIdx];

                  if (col == leftSeats || col == leftSeats + centerSeats + 1) {
                    return const SizedBox.shrink();
                  }

                  int adjustedCol = col;
                  if (col > leftSeats && col < leftSeats + centerSeats + 1) {
                    adjustedCol -= 1;
                  } else if (col > leftSeats + centerSeats + 1) {
                    adjustedCol -= 2;
                  }

                  final seatNumber = adjustedCol + 1;
                  final seatId = '$row$seatNumber';
                  final isReserved = seats.any((seat) =>
                  seat.row.toUpperCase() == row.toUpperCase() &&
                      seat.column == seatNumber &&
                      seat.reserved == true);
                  final isSelected = selectedSeats.contains(seatId);

                  Color seatColor;
                  if (isReserved) {
                    seatColor = Colors.grey.shade600;
                  } else if (isSelected) {
                    seatColor = Colors.red.shade700;
                  } else {
                    seatColor = Colors.black;
                  }

                  return GestureDetector(
                    onTap: isReserved
                        ? null
                        : () {
                      setState(() {
                        if (isSelected) {
                          selectedSeats.remove(seatId);
                        } else {
                          if (selectedSeats.length < totalAllowed) {
                            selectedSeats.add(seatId);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('선택 가능한 인원을 초과했습니다.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          if (!isReserved)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        seatId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ℹ️ 하단 정보 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('극장 : ${widget.theater}', style: const TextStyle(fontSize: 16)),
                    Text('영화 : ${widget.movieTitle}', style: const TextStyle(fontSize: 16)),
                    Text(
                      '일시 : ${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')} | ${widget.time}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text('인원 : 일반 ${widget.generalCount}명 | 청소년 ${widget.youthCount}명',
                        style: const TextStyle(fontSize: 16)),

                    const SizedBox(height: 8),

                    Text(
                      '금액: ${totalPrice}원',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: selectedSeats.length == totalAllowed
                            ? () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (_) => _buildSummaryBottomSheet(context),
                          );
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          '다음',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🟩 좌석 범례 박스 위젯
  Widget _seatLegendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSummaryBottomSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Center(
              child: Text(
                '예매 정보 요약',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // 🎟️ 티켓 박스
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎬 영화 : ${widget.movieTitle}'),
                  Text('🏢 극장 : ${widget.theater}'),
                  Text('🕒 시간 : ${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')} | ${widget.time}'),
                  Text('👥 인원 : 일반 ${widget.generalCount}명 | 청소년 ${widget.youthCount}명'),
                  Text('💺 좌석 : ${selectedSeats.join(', ')}'),
                  Text('💰 총 금액 : ${totalPrice}원'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('결제 완료!')),
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('결제하기', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


}
