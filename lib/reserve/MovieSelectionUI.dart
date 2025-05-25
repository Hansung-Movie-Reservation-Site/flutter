import 'package:flutter/material.dart';
import 'package:movie/Common/ApiService.dart';
import 'SeatPage.dart';

class MovieSelectionUI extends StatefulWidget {
  final String selectedCinema;
  final DateTime selectedDate;

  const MovieSelectionUI({
    super.key,
    required this.selectedCinema,
    required this.selectedDate,
  });

  @override
  State<MovieSelectionUI> createState() => _MovieSelectionUIState();
}

class _MovieSelectionUIState extends State<MovieSelectionUI> {
  DateTime? selectedDate;
  final PageController _pageController = PageController(viewportFraction: 0.95);
  final int daysPerPage = 4;
  String? cinema;
  int currentPage = 0;

  List<Map<String, dynamic>>? movies;

  Future<void> loadGroupedMovies(String spotName, String date) async {
    final api = ApiService();
    final screenings = await api.fetchScreenings(spotName, date);

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final s in screenings) {
      grouped.putIfAbsent(s.title, () => []);
      grouped[s.title]!.add({
        "id": s.id,
        "time": s.start.substring(0, 5),
      });
    }

    setState(() {
      movies = grouped.entries.map((e) => {
        "title": e.key,
        "times": e.value,
      }).toList();
    });
  }




  List<DateTime> generateDates() {
    final today = DateTime.now();
    return List.generate(14, (index) => today.add(Duration(days: index)));
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _weekdayToKorean(int weekday) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  void _goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _totalPages) {
      setState(() => currentPage = pageIndex);
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  int get _totalPages => (generateDates().length / daysPerPage).ceil();

  @override
  void initState() {
    super.initState();
    selectedDate = generateDates().first;
    loadGroupedMovies(widget.selectedCinema, widget.selectedDate.toString().split(" ")[0]);
    cinema = widget.selectedCinema;

  }

  @override
  Widget build(BuildContext context) {
    if (movies == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final allDates = generateDates();
    final paginatedDates = List.generate(
      _totalPages,
          (index) {
        final start = index * daysPerPage;
        final end = (start + daysPerPage).clamp(0, allDates.length);
        return allDates.sublist(start, end);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 선택 바 (PageView + 좌우 버튼)
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
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemBuilder: (context, pageIndex) {
                    final dates = paginatedDates[pageIndex];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: dates.map((date) {
                          final isSelected = selectedDate != null &&
                              date.year == selectedDate!.year &&
                              date.month == selectedDate!.month &&
                              date.day == selectedDate!.day;

                          return GestureDetector(
                            onTap: () => setState(() => selectedDate = date),
                            child: Container(
                              width: 75,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white, // 항상 흰색 배경
                                border: Border.all(
                                  color: isSelected ? Colors.red.shade800 : Colors.grey.shade400,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_twoDigits(date.month)}.${_twoDigits(date.day)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // <- 항상 검정색
                                    ),
                                  ),
                                  Text(
                                    _weekdayToKorean(date.weekday),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54, // <- 항상 동일한 회색
                                    ),
                                  ),

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

        // 영화 목록
        Expanded(
          child: ListView.separated(
            itemCount: movies!.length,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Colors.black, thickness: 1),
            ),
            itemBuilder: (context, index) {
              final movie = movies![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text('포스터', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          movie['title'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // 영화 상세 정보 이동
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          minimumSize: const Size(70, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text('영화정보', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      movie['times'].length,
                          (timeIndex) {
                        final timeInfo = movie['times'][timeIndex];
                        final time = timeInfo['time'];
                        final screeningId = timeInfo['id'];

                        return GestureDetector(
                          onTap: () {
                            _showTimeDetailBottomSheet(movie['title'], time, screeningId);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(time, style: const TextStyle(fontSize: 14)),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // 인원수 선택 창
  void _showTimeDetailBottomSheet(String movieTitle, String time, int screeningId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white, // 배경 흰색
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        int generalCount = 0;
        int youthCount = 0;

        DateTime startTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          int.parse(time.split(':')[0]),
          int.parse(time.split(':')[1]),
        );
        DateTime endTime = startTime.add(const Duration(hours: 2)); // 대략 2시간

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: SingleChildScrollView( // 높이 확장 + 스크롤 가능
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      '$movieTitle',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '날짜 : ${selectedDate!.year}.${selectedDate!.month}.${selectedDate!.day}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      '상영 시간 : $time ~ ${_twoDigits(endTime.hour)}:${_twoDigits(endTime.minute)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text('극장 : $cinema', style: TextStyle(fontSize: 18)),

                    const SizedBox(height: 24),
                    const Text(
                      '인원 수 선택',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCounter('일반', generalCount, (val) => setState(() => generalCount = val)),
                        _buildCounter('청소년', youthCount, (val) => setState(() => youthCount = val)),
                      ],
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionPage(
                                movieTitle: movieTitle,
                                theater: 'CGV 강남',
                                time: time,
                                date: selectedDate!,
                                generalCount: generalCount,
                                youthCount: youthCount,
                                screeningId: screeningId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          '좌석 선택',
                          style: TextStyle(fontSize: 18, color: Colors.white), // 하얀 글자
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounter(String label, int value, void Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text('$value', style: const TextStyle(fontSize: 18)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

}

