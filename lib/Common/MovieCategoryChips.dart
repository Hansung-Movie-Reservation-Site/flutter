
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieCategoryChips extends StatefulWidget {
  const MovieCategoryChips({super.key});

  @override
  State<MovieCategoryChips> createState() => _MovieCategoryChipsState();
}

class _MovieCategoryChipsState extends State<MovieCategoryChips> {
  final List<String> categories = ['내 극장만', '별점 순', '관객수 순'];
  String selectedCategory = '별점 순'; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Wrap(
          spacing: 10, // Chip 간 간격
          alignment: WrapAlignment.center, // 가로 중앙 정렬
          children: categories.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              selectedColor: Colors.redAccent,
              backgroundColor: Colors.grey[200],
              labelStyle: const TextStyle(
                color: Colors.black,
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
      ),
    );
  }
}

