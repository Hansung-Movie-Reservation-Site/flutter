import 'package:flutter/material.dart';

class SearchModalWidget extends StatefulWidget {
  final Function(String keyword) onSearch;

  const SearchModalWidget({super.key, required this.onSearch});

  @override
  State<SearchModalWidget> createState() => _SearchModalWidgetState();
}

class _SearchModalWidgetState extends State<SearchModalWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '영화 검색',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '영화 제목을 입력하세요',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onSubmitted: (value) {
              widget.onSearch(value); // 부모로 검색어 전달
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('닫기', style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
