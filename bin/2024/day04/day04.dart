import 'dart:async';
import 'dart:convert';
import 'package:advent_of_code/runnable.dart';

class Y2024Day04 extends Runnable {
  List<String> input = [];
  int xmax = 0;
  int ymax = 0;
  final Map<(int, int), String> _letters = {};

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    ymax = lines.length - 1;
    xmax = lines[0].length - 1;

    for (int y = 0; y <= ymax; y++) {
      for (int x = 0; x <= xmax; x++) {
        _letters[(x, y)] = lines[y][x];
      }
    }
  }

  @override
  void part1() {
    final word = 'XMAS'.split('');
    List<(int, int)> dirs = [
      (1, 0),
      (-1, 0),
      (0, 1),
      (0, -1),
      (1, 1),
      (-1, -1),
      (-1, 1),
      (1, -1)
    ];
    int sum = 0;

    for (final start in _letters.entries.where((l) => l.value == word[0])) {
      for (final dir in dirs) {
        bool found = true;

        for (int dist = 1; found && dist < word.length; dist++) {
          final next = _letters[(
            start.key.$1 + dist * dir.$1,
            start.key.$2 + dist * dir.$2
          )];

          found = next == word[dist];
        }

        if (found) sum++;
      }
    }

    print("Found: $sum");
  }

  @override
  void part2() {
    int sum = 0;
    final positions = [
      ((-1, 1), (1, -1)),
      ((1, -1), (-1, 1)),
      ((-1, -1), (1, 1)),
      ((1, 1), (-1, -1))
    ];

    for (final MapEntry(key: a)
        in _letters.entries.where((l) => l.value == 'A')) {
      int found = 0;

      for (final (start, end) in positions) {
        if (_letters[(a.$1 + start.$1, a.$2 + start.$2)] == 'M' &&
            _letters[(a.$1 + end.$1, a.$2 + end.$2)] == 'S') {
          found++;
        }
      }

      if (found > 1) sum++;
    }

    print("Found: $sum");
  }
}
