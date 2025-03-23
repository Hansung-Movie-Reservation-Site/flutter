import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieCategoryChips extends StatefulWidget {
  const MovieCategoryChips({super.key});

  @override
  State<MovieCategoryChips> createState() => _MovieCategoryChipsState();
}

class _MovieCategoryChipsState extends State<MovieCategoryChips> {
  late final DateTime date;
  final List<String> categories = [/*데이터 받아서 이곳에 삽입*/];
  String selectedCategory = ''; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Wrap(
        spacing: 10, // Chip 간 간격
        children: categories.map((category) {
          bool isSelected = category == selectedCategory;
          return ChoiceChip(
            label: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black, // 선택시 글자 색상 변환
                fontWeight: FontWeight.bold,
              ),
            ),
            selected: isSelected,
            selectedColor: Colors.redAccent, // 선택된 배경색
            backgroundColor: Colors.grey[200], // 선택 안 됐을 때 배경색
            onSelected: (_) {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
