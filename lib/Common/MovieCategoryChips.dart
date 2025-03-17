
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieCategoryChips extends StatefulWidget {
  const MovieCategoryChips({super.key});

  @override
  State<MovieCategoryChips> createState() => _MovieCategoryChipsState();
}

class _MovieCategoryChipsState extends State<MovieCategoryChips> {
  final List<String> categories = ['액션', '코미디', '드라마', '애니메이션'];
  String selectedCategory = '액션'; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Wrap(
        spacing: 10, // Chip 간 간격
        children: categories.map((category) {
          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            selectedColor: Colors.redAccent, // 선택된 배경색
            backgroundColor: Colors.grey[200], // 선택 안 됐을 때 배경색
            labelStyle: TextStyle(
              color: selectedCategory == category ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
