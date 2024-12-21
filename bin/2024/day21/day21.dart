import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

final class Y2024Day21 extends Runnable {
  static const Map<String, (int, int)> _numPad = {
    "7": (0, 0),
    "8": (1, 0),
    "9": (2, 0),
    "4": (0, 1),
    "5": (1, 1),
    "6": (2, 1),
    "1": (0, 2),
    "2": (1, 2),
    "3": (2, 2),
    "X": (0, 3),
    "0": (1, 3),
    "A": (2, 3)
  };
  static const Map<String, (int, int)> _dPad = {
    "X": (0, 0),
    "^": (1, 0),
    "A": (2, 0),
    "<": (0, 1),
    "v": (1, 1),
    ">": (2, 1)
  };
  final List<String> _codes = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _codes.addAll(lines);
  }

  String getPath(Map<String, (int, int)> pad, String from, String to) {
    final spos = pad[from]!, epos = pad[to]!, forbidden = pad['X']!;
    final dx = epos.$1 - spos.$1, dy = epos.$2 - spos.$2;
    final h = (dx < 0 ? "<" : ">") * dx.abs();
    final v = (dy < 0 ? "^" : "v") * dy.abs();

    if (dx < 0 && (epos.$1, spos.$2) != forbidden ||
        (spos.$1, epos.$2) == forbidden) {
      return "$h${v}A";
    }

    return "$v${h}A";
  }

  int getLength(Map<(String, int), int> cache, String seq, int depth) {
    if (cache.containsKey((seq, depth))) {
      return cache[(seq, depth)]!;
    }

    if (depth == 0) return seq.length;

    int count = 0;

    String prev = "A";
    for (int i = 0; i < seq.length; i++) {
      count += getLength(cache, getPath(_dPad, prev, seq[i]), depth - 1);
      prev = seq[i];
    }

    cache[(seq, depth)] = count;
    return count;
  }

  int getComplexity(int robots) {
    int complexity = 0;
    final Map<(String, int), int> cache = {};

    for (final code in _codes) {
      int numPart = int.parse(code.replaceAll("A", ""));
      String movements = "";
      String prev = "A";

      for (final digit in code.split("")) {
        movements += getPath(_numPad, prev, digit);
        prev = digit;
      }

      final count = getLength(cache, movements, robots);
      complexity += numPart * count;
    }

    return complexity;
  }

  @override
  void part1() {
    print("Total complexity: ${getComplexity(2)}");
  }

  @override
  void part2() {
    print("Total complexity: ${getComplexity(25)}");
  }
}
