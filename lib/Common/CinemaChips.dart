import 'package:flutter/material.dart';

class ScreeningTime {
  final int id;
  final String start;
  final String finish;
  final int availableSeats;// 잔여 좌석 수
  final int roomId;

  ScreeningTime({
    required this.id,
    required this.start,
    required this.finish,
    required this.availableSeats,
    required this.roomId,
  });

  factory ScreeningTime.fromJson(Map<String, dynamic> json) {
    return ScreeningTime(
      id: json['id'],
      start: json['start'],
      finish: json['finish'],
      availableSeats: json['availableSeats'],
      roomId: json['roomId'],
    );
  }

  String get displayText => '$start ~ $finish';
}

class CinemaChips extends StatefulWidget {
  final List<ScreeningTime> information;

  const CinemaChips({super.key, required this.information});

  @override
  State<CinemaChips> createState() => _CinemaChipsState();
}

class _CinemaChipsState extends State<CinemaChips> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.information.map((time) {
            bool isSelected = time.id == selectedId;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time.displayText,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '잔여좌석: ${time.availableSeats}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedColor: Colors.redAccent,
                backgroundColor: Colors.grey[200],
                onSelected: (_) {
                  setState(() {
                    selectedId = time.id;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
