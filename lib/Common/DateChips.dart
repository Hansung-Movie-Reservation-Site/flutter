import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChips extends StatefulWidget {
  const DateChips({super.key});

  @override
  State<DateChips> createState() => _DateChipsState();
}

class _DateChipsState extends State<DateChips> {
  late List<DateTime> dateList;
  late DateTime selectedDate;

  late DateFormat chipFormatter;
  late DateFormat fullFormatter;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    chipFormatter = DateFormat('dd일'); // 칩에 보여줄 포맷
    fullFormatter = DateFormat('MM월 dd일 (E)', 'ko'); // 전체 텍스트 포맷

    dateList = List.generate(7, (index) => now.add(Duration(days: index)));
    selectedDate = dateList[0]; // 기본값: 오늘
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 중앙에 전체 날짜 텍스트
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            fullFormatter.format(selectedDate), // 선택된 날짜 전체 표현
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 가로 스크롤 칩
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dateList.map((date) {
                final isSelected = selectedDate == date;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      chipFormatter.format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.redAccent,
                    backgroundColor: Colors.grey[200],
                    onSelected: (_) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
