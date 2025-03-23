import 'package:flutter/material.dart';

class PaymentCancelUI extends StatefulWidget {
  final List<Map<String, String>> paymentcancel;

  const PaymentCancelUI({Key? key, required this.paymentcancel}) : super(key: key);

  @override
  _PaymentCancelUIState createState() => _PaymentCancelUIState();
}

class _PaymentCancelUIState extends State<PaymentCancelUI> {
  int _visibleCount = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: (_visibleCount < widget.paymentcancel.length)
                ? _visibleCount + 1
                : widget.paymentcancel.length, // 모든 데이터 로드 시 버튼 제외
            itemBuilder: (context, index) {
              if (index == _visibleCount && _visibleCount < widget.paymentcancel.length) {
                // '더보기' 버튼 표시
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
                        side: BorderSide(color: Colors.grey.shade400), // 테두리 추가
                      ),
                    ),
                    child: Text("더보기", style: TextStyle(fontSize: 16)),
                  ),
                );
              }

              final reservation = widget.paymentcancel[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reservation["title"]!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "예매 날짜 : ${reservation["date"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "영화관 : ${reservation["theater"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "가격 : ${reservation["price"]}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "결제취소",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
