import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Maintab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          SizedBox(
            height: 200, // ← TabBarView의 높이 설정 꼭 필요
            child: TabBarView(
              children: [
                Center(child: Text('탭1 내용')),
                Center(child: Text('탭2 내용')),
                Center(child: Text('탭3 내용')),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 0),
                tabs: const [
                  Tab(text: '탭1'),
                  Tab(text: '탭2'),
                  Tab(text: '탭3'),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
