import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';

typedef Point = (int, int);

final class Y2024Day10 extends Runnable {
  Map<Point, int> map = {};
  int ymax = -1;
  int xmax = -1;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = (await input.transform(LineSplitter()).toList());

    ymax = lines.length;
    xmax = lines[0].length;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        if (lines[y][x] != '.') {
          map[(x, y)] = int.parse(lines[y][x]);
        }
      }
    }
  }

  int reachOne(Point p, Set<Point> walkedNines, [int score = 0]) {
    if (score == 9) {
      if (walkedNines.contains(p)) return 0;
      walkedNines.add(p);
      return 1;
    }

    return [(0, 1), (0, -1), (1, 0), (-1, 0)].fold(0, (agg, diff) {
      final next = (p.$1 + diff.$1, p.$2 + diff.$2);
      final val = map[next];
      return val == score + 1 ? agg + reachOne(next, walkedNines, val!) : agg;
    });
  }

  @override
  void part1() {
    final trails = map.keys
        .where((key) => map[key] == 0)
        .fold(0, (agg, pos) => agg + reachOne(pos, {}));

    print("There are $trails trails");
  }

  int walkAll(Point p, [int score = 0]) {
    if (score == 9) return 1;

    return [(0, 1), (0, -1), (1, 0), (-1, 0)].fold(0, (agg, diff) {
      final next = (p.$1 + diff.$1, p.$2 + diff.$2);
      final val = map[next];
      return val == score + 1 ? agg + walkAll(next, val!) : agg;
    });
  }

  @override
  void part2() {
    final trails = map.keys
        .where((key) => map[key] == 0)
        .fold(0, (agg, pos) => agg + walkAll(pos));

    print("There are $trails trails");
  }
}
