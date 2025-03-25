import 'package:flutter/material.dart';
import 'package:movie/reserve/steps/StepMovie.dart';
import 'package:movie/reserve/steps/StepPayment.dart';
import 'package:movie/reserve/steps/StepSeats.dart';
import 'package:movie/reserve/steps/StepTheather.dart';// Movie 화면 (step 값에 따라 다른 화면 표시)
class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  int step = 1; // 초기 스텝 값

  void nextStep() {
    setState(() {
      if (step < 3) step++;
    });
  }

  void previousStep() {
    setState(() {
      if (step > 1) step--;
    });
  }

  // step 값에 따라 다른 위젯 반환
  Widget getStepWidget() {
    switch (step) {
      case 1:
        return StepMovie();
      case 2:
        return StepTheather();
      case 3:
        return StepSeats();
      default:
        return StepPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Step $step")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getStepWidget(), // 현재 step에 맞는 컴포넌트 표시
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: previousStep,
                child: Text("Previous"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: nextStep,
                child: Text("Next"),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 홈으로 돌아가기
            },
            child: Text("Back to Home"),
          ),
        ],
      ),
    );
  }
}