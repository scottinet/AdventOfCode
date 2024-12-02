import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

class Y2024Day02 extends Runnable {
  List<String> input = [];
  final List<List<int>> reports = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      reports.add(line.split(' ').map((l) => int.parse(l)).toList());
    }
  }

  int _countSafeReports({required bool dampener}) {
    int safeReports = 0;

    for (final levels in reports) {
      int sign = levels[1] - levels[0];
      int prev = levels[0];
      bool dampened = !dampener;
      bool safe = true;

      for (int i = 1; safe && i < levels.length; i++) {
        final dist = levels[i] - prev;

        if (dist == 0 || dist.abs() > 3 || sign * dist < 0) {
          if (!dampened) {
            dampened = true;
          } else {
            safe = false;
          }
        } else {
          prev = levels[i];
        }
      }

      if (safe) safeReports++;
    }

    return safeReports;
  }

  @override
  void part1() {
    final safeReports = _countSafeReports(dampener: false);

    print("Safe reports: $safeReports");
  }

  @override
  void part2() {
    final safeReports = _countSafeReports(dampener: true);

    print("Safe reports: $safeReports");
  }
}
