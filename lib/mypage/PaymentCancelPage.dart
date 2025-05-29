import 'package:flutter/material.dart';
import 'package:movie/auth/Apiservicev2.dart';
import 'package:movie/mypage/Mypage_login.dart';
import 'package:movie/mypage/PaymentCancelUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Response/OrderSummary.dart';

// 우선 샘플 데이터로 화면 구성, API 연동 추가 예정

class PaymentCancelScreen extends StatefulWidget {
  @override
  State<PaymentCancelScreen> createState() => _PaymentCancelScreenState();
}

class _PaymentCancelScreenState extends State<PaymentCancelScreen> {
  Future<List<OrderSummary>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId != null) {
      setState(() {
        _ordersFuture = Apiservicev2().fetchOrders(userId);
      });
    } else {
      setState(() {
        _ordersFuture = Future.value([]); // 빈 리스트 반환
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('예매 내역 / 결제 취소', style: TextStyle(fontSize: 27, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _ordersFuture == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<OrderSummary>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('결제 내역이 없습니다.'));
          }
          return PaymentCancelUI(paymentcancel: snapshot.data!, onOrderCanceled: _loadOrders,);
        },
      ),
    );
  }
}
