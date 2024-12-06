import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

class Y2024Day06 extends Runnable {
  Map<(int, int), String> map = {};
  (int, int) start = (-1, -1);

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final ymax = lines.length;
    final xmax = lines[0].length;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        final char = lines[y][x];

        if (char == '^') {
          start = (x, y);
          map[(x, y)] = '.';
        } else {
          map[(x, y)] = char;
        }
      }
    }
  }

  @override
  void part1() {
    final dirs = [(0, -1), (1, 0), (0, 1), (-1, 0)];
    (int, int) pos = start;
    (int, int) vect = dirs[0];
    int dirIndex = 0;
    Set<(int, int)> walked = {start};

    while (true) {
      final next = (pos.$1 + vect.$1, pos.$2 + vect.$2);
      var value = map[next];

      if (value == null) {
        break;
      } else if (value == '#') {
        dirIndex = (dirIndex + 1) % dirs.length;
        vect = dirs[dirIndex];
      } else {
        walked.add(next);
        pos = next;
      }
    }

    print("Walked: ${walked.length}");
  }

  @override
  void part2() {}
}
