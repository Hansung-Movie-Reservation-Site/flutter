import 'package:flutter/material.dart';
import 'package:movie/auth/Apiservicev2.dart';

import '../Common/DialogMaker.dart';
import '../Response/OrderSummary.dart';

class PaymentCancelUI extends StatefulWidget {
  final List<OrderSummary> paymentcancel;
  final VoidCallback? onOrderCanceled;

  const PaymentCancelUI({Key? key, required this.paymentcancel, this.onOrderCanceled}) : super(key: key);

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
                : widget.paymentcancel.length,
            itemBuilder: (context, index) {
              if (index == _visibleCount && _visibleCount < widget.paymentcancel.length) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _visibleCount += 5;
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
                    child: Text("더보기", style: TextStyle(fontSize: 16)),
                  ),
                );
              }

              final order = widget.paymentcancel[index];
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
                                image: order.posterImage != null
                                    ? DecorationImage(
                                  image: NetworkImage(order.posterImage!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: order.posterImage == null
                                  ? Center(child: Icon(Icons.image, size: 40, color: Colors.grey[600]))
                                  : null,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 30),
                                  Text("예매 날짜 : ${order.date}", style: TextStyle(fontSize: 14)),
                                  Text("영화관 : ${order.theater}", style: TextStyle(fontSize: 14)),
                                  Text("가격 : ${order.price}", style: TextStyle(fontSize: 14)),
                                  Text("결제 상태 : ${order.tid}", style: TextStyle(fontSize: 14)),
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
                          onPressed: () async {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('결제취소 확인'),
                                content: Text('정말로 결제를 취소하시겠습니까?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('아니오')),
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('예')),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              final api = Apiservicev2();
                              bool result = await api.cancelOrder(order.id);
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('결제 취소가 완료되었습니다.')),
                                );
                                widget.onOrderCanceled?.call();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('결제 취소에 실패했습니다.')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("결제취소", style: TextStyle(fontSize: 14, color: Colors.white)),
                        )
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

