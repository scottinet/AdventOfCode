import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

class Y2024Day01 extends Runnable {
  List<String> input = [];
  List<int> left = [];
  List<int> right = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final pattern = RegExp(r'\s+');

    for (final line in lines) {
      final [l, r] = line.split(pattern);

      left.add(int.parse(l));
      right.add(int.parse(r));
    }
  }

  @override
  void part1() {
    left.sort();
    right.sort();
    int distSum = 0;

    for (int i = 0; i < left.length; i++) {
      distSum += (left[i] - right[i]).abs();
    }

    print('Total distance: $distSum');
  }

  @override
  void part2() {
    Map<int, int> scores = {};

    for (final item in right) {
      if (scores.containsKey(item)) {
        scores[item] = scores[item]! + 1;
      } else {
        scores[item] = 1;
      }
    }

    int similarityScore = 0;

    for (final item in left) {
      final score = scores[item];

      if (score != null) {
        similarityScore += item * score;
      }
    }

    print('Score: $similarityScore');
  }
}
