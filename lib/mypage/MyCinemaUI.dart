import 'package:flutter/material.dart';
import 'package:movie/Response/MyTheater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCinemaUI {
  // 현재 선택된 영화관 정보 표시
  static Widget buildCinemaInfo(List<MyTheater> selectedCinema, Map<String, Map<int, String>> spotData) {
    // spotId를 이름으로 매핑
    List<String> cinemaNames = [];
    for (var theater in selectedCinema) {
      for (var entry in spotData.entries) {
        if (entry.value.containsKey(theater.spotId)) {
          cinemaNames.add(entry.value[theater.spotId]!);
          break;
        }
      }
    }

    return Container(
      width: 360,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade900, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_movies,
            color: Colors.black,
            size: 32,
          ),
          const SizedBox(width: 10),
          const Text(
            "내 영화관",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cinemaNames.isNotEmpty ? cinemaNames.join(", ") : "선택된 영화관 없음",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // 영화관 선택 UI (지역 선택 + 하위 영화관 리스트)
  static Widget buildCinemaSelection({
    required Map<String, List<String>> cinemaMap,
    required String? selectedRegion,
    required String? selectedCinema,
    required List<String> recentCinemas,
    required String? selectedRecentCinema,
    required Function(String) onRegionSelected,
    required Function(String) onCinemaSelected,
    required Function(String) onRecentCinemaSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '지역',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),

        // 지역 선택 버튼 리스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 10,
            children: cinemaMap.keys.map((region) {
              return GestureDetector(
                onTap: () {
                  onRegionSelected(region);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedRegion == region
                          ? Colors.red.shade800
                          : Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    region,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // 하위 영화관 리스트 (지역 선택 시만 표시)
        if (selectedRegion != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '극장',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  children: cinemaMap[selectedRegion]!.map((cinema) {
                    return GestureDetector(
                      onTap: () {
                        // Select cinema and reset recent cinema selection
                        onCinemaSelected(cinema);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedCinema == cinema
                              ? Colors.red.shade800
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedCinema == cinema
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                        child: Text(
                          cinema,
                          style: TextStyle(
                            color: selectedCinema == cinema
                                ? Colors.black
                                : Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

        const SizedBox(height: 30),
      ],
    );
  }


  // 영화관 지정 버튼 UI
  static Widget buildSelectButton(BuildContext context, VoidCallback onPressed) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              onPressed();
            },
            child: const Text(
              '영화관 지정',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}


