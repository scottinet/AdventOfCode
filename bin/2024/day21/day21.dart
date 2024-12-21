import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

final class Y2024Day21 extends Runnable {
  static const Map<String, (int, int)> _numKeypad = {
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
  static const Map<String, (int, int)> _digitalKeypad = {
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

  String getPadPath(Map<String, (int, int)> pad, String from, String to) {
    bool toReverse = false;
    final spos = pad[from]!, epos = pad[to]!, forbidden = pad['X'];
    (int, int) pos = spos;
    (int, int) diff = (epos.$1 - spos.$1, epos.$2 - spos.$2);
    final List<String> path = [];

    while (diff != (0, 0)) {
      if (diff.$1 != 0) {
        final toApply = diff.$1 ~/ diff.$1.abs();
        diff = (diff.$1 - toApply, diff.$2);
        pos = (pos.$1 + toApply, pos.$2);
        path.add(toApply < 0 ? "<" : ">");
      } else {
        final toApply = diff.$2 ~/ diff.$2.abs();
        path.add(toApply < 0 ? "^" : "v");
        diff = (diff.$1, diff.$2 - toApply);
        pos = (pos.$1, toApply + pos.$2);
      }

      toReverse = toReverse || pos == forbidden;
    }

    return (toReverse ? path.reversed : path).join("");
  }

  @override
  void part1() {
    int complexity = 0;

    for (final code in _codes) {
      int numPart = int.parse(code.replaceAll("A", ""));
      List<String> movements = [];
      String prev = "A";

      for (final digit in code.split("")) {
        movements.add("${getPadPath(_numKeypad, prev, digit)}A");
        prev = digit;
      }

      for (int i = 0; i < 2; i++) {
        final sequence = movements.join("");
        prev = "A";
        movements.clear();

        for (int j = 0; j < sequence.length; j++) {
          movements.add("${getPadPath(_digitalKeypad, prev, sequence[j])}A");
          prev = sequence[j];
        }
      }
      complexity += numPart * movements.fold(0, (agg, val) => agg + val.length);
    }

    print("Total complexity: $complexity");
  }

  @override
  void part2() {}
}
