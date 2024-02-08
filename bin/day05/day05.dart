import 'dart:async';
import 'dart:convert';

import 'package:aoc2015/models/runnable.model.dart';

class Day05 extends Runnable {
  List<String> input = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    this.input = await input.transform(LineSplitter()).toList();
  }

  @override
  void part1() {
    const naughtyIndicators = ['ab', 'cd', 'pq', 'xy'];
    int niceCount = 0;

    for (final word in input) {
      bool isNice = RegExp(r'[aeiou]').allMatches(word).length >= 3 &&
          RegExp(r'(.)\1').hasMatch(word) &&
          !naughtyIndicators.any((indicator) => word.contains(indicator));

      if (isNice) {
        niceCount++;
      }
    }

    print('Nices: $niceCount');
  }

  @override
  void part2() {
    int niceCount = 0;

    for (final word in input) {
      bool isNice = RegExp(r'(.).\1').hasMatch(word) &&
          RegExp(r'(..).*\1').hasMatch(word);

      if (isNice) niceCount++;
    }

    print('Nices: $niceCount');
  }
}
