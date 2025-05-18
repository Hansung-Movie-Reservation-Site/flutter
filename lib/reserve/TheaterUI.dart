import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/ApiService.dart';
import '../Common/navbar.dart';
import 'MovieSelectionPage.dart';

class TheaterUI extends StatefulWidget {
  const TheaterUI({super.key});

  @override
  State<TheaterUI> createState() => _TheaterUIState();
}

class _TheaterUIState extends State<TheaterUI> {
  String? selectedRegion;
  String? selectedCinema;
  DateTime? selectedDate;
  String searchKeyword = '';
  int? userId;
  String? userCinema;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    userCinema = prefs.getString('user_cinema');
    await loadCinemaMap();
  }

  final PageController _pageController = PageController(viewportFraction: 1.0);
  final int daysPerPage = 3;

  int currentPage = 0;

  Map<String, List<String>> cinemaMap = {};

  Future<void> loadCinemaMap() async {
    final api = ApiService();
    final regions = await api.fetchRegions();
    final spots = await api.fetchSpots();

    Map<String, List<String>> tempMap = {
      '내영화관': userCinema != null ? [userCinema!] : [],
    };

    for (var region in regions) {
      tempMap[region.name] = spots
          .where((spot) => spot.region.id == region.id)
          .map((spot) => spot.name)
          .toList();
    }

    setState(() {
      cinemaMap = tempMap;
    });
  }

  List<DateTime> generateDates() {
    final today = DateTime.now();
    return List.generate(14, (index) => today.add(Duration(days: index)));
  }

  String _weekdayToKorean(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _totalPages) {
      setState(() {
        currentPage = pageIndex;
      });
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  int get _totalPages => (generateDates().length / daysPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final allDates = generateDates();

    List<List<DateTime>> paginatedDates = List.generate(
      _totalPages,
          (pageIndex) {
        final start = pageIndex * daysPerPage;
        final end = (start + daysPerPage) > allDates.length
            ? allDates.length
            : (start + daysPerPage);
        return allDates.sublist(start, end);
      },
    );

    final filteredCinemas = searchKeyword.isEmpty
        ? null
        : cinemaMap.entries
        .expand((entry) => entry.value)
        .where((cinema) => cinema.contains(searchKeyword))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '예매',
          style: TextStyle(fontSize: 27, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedCinema != null && selectedDate != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.red.shade800,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.movie, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '극장 : $selectedCinema  |  날짜 : ${selectedDate!.year}.${_twoDigits(selectedDate!.month)}.${_twoDigits(selectedDate!.day)} (${_weekdayToKorean(selectedDate!.weekday)})',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            const Text('극장',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 🔍 영화관 검색창
            TextField(
              decoration: InputDecoration(
                labelText: '영화관 검색',
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchKeyword = value.trim();
                });
              },
            ),
            const SizedBox(height: 15),

            // 📍 검색 결과 리스트 또는 지역별 리스트
            Flexible(
              child: searchKeyword.isNotEmpty && filteredCinemas!.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: searchKeyword.isEmpty
                    ? cinemaMap.entries.map((entry) {
                  final region = entry.key;
                  final cinemas = entry.value;
                  return ExpansionTile(
                    title: Text(region,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    children: cinemas.map((cinema) {
                      final isSelected =
                          selectedCinema == cinema;
                      return ListTile(
                        title: Text(cinema),
                        trailing: isSelected
                            ? const Icon(Icons.check,
                            color: Colors.red)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedRegion = region;
                            selectedCinema = cinema;
                          });
                        },
                      );
                    }).toList(),
                  );
                }).toList()
                    : filteredCinemas?.map((cinema) {
                  final isSelected =
                      selectedCinema == cinema;
                  return ListTile(
                    title: Text(cinema),
                    trailing: isSelected
                        ? const Icon(Icons.check,
                        color: Colors.red)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedCinema = cinema;
                        selectedRegion = cinemaMap.entries
                            .firstWhere((entry) =>
                            entry.value.contains(cinema))
                            .key;
                        searchKeyword = '';
                      });
                    },
                  );
                }).toList() ??
                    [],
              ),
            ),
            const SizedBox(height: 10),
            const Text('날짜',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 📅 날짜 선택
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => _goToPage(currentPage - 1),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _totalPages,
                      onPageChanged: (index) {
                        setState(() => currentPage = index);
                      },
                      itemBuilder: (context, pageIndex) {
                        final dates = paginatedDates[pageIndex];
                        return Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: dates.map((date) {
                              final isSelected = selectedDate != null &&
                                  date.year == selectedDate!.year &&
                                  date.month == selectedDate!.month &&
                                  date.day == selectedDate!.day;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                                child: Container(
                                  width: 60,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.red.shade800
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${_twoDigits(date.month)}.${_twoDigits(date.day)}',
                                          style:
                                          const TextStyle(fontSize: 13)),
                                      Text(
                                          '(${_weekdayToKorean(date.weekday)})',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _goToPage(currentPage + 1),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🎫 조회 버튼
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedCinema != null && selectedDate != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieselectionPage(
                            selectedCinema: selectedCinema!,
                            selectedDate: selectedDate!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('영화관과 날짜를 선택해주세요.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('조회하기',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
