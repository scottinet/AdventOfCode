import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';
import 'package:collection/collection.dart';

final class Y2024Day14 extends Runnable {
  final List<Vector> _robots = [];
  int xmax = 101;
  int ymax = 103;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    if (args.contains('--xmax')) {
      xmax = int.parse(args[args.indexOf('--xmax') + 1]);
      assert(!xmax.isNaN);
    }

    if (args.contains('--ymax')) {
      ymax = int.parse(args[args.indexOf('--ymax') + 1]);
      assert(!ymax.isNaN);
    }

    for (final line in lines) {
      List<int> robot = line
          .split(RegExp(r'[ ,]'))
          .map((n) => int.parse(n.replaceAll(RegExp(r'[^\d-]'), '')))
          .toList();
      _robots.add(Vector(pos: (robot[0], robot[1]), dir: (robot[2], robot[3])));
    }

    print("Grid: $xmax wide, $ymax tall");
  }

  @override
  void part1() {
    final midx = (xmax - 1) ~/ 2, midy = (ymax - 1) ~/ 2;
    final robots = _robots
        .map((r) => r.advance(100))
        .map((r) => Vector(pos: (r.x % xmax, r.y % ymax), dir: r.dir));
    Map<(bool, bool), int> quadrants = {};

    for (final robot in robots) {
      if (robot.x == midx || robot.y == midy) continue;
      final isLeft = robot.x < midx;
      final isTop = robot.y < midy;

      quadrants[(isLeft, isTop)] = (quadrants[(isLeft, isTop)] ?? 0) + 1;
    }

    print(
        'Safety factor: ${quadrants.values.fold(1, (agg, val) => agg * val)}');
  }

  List<Vector> moveOnce(List<Vector> robots) {
    return robots
        .map((r) => r.advance())
        .map((r) => Vector(pos: (r.x % xmax, r.y % ymax), dir: r.dir))
        .toList();
  }

  void show(List<Vector> robots) {
    for (int y = 0; y < ymax; y++) {
      String str = '';

      for (int x = 0; x < xmax; x++) {
        str += (robots.firstWhereOrNull((r) => r.pos == (x, y)) != null)
            ? '█'
            : '.';
      }

      print(str);
    }

    print("====================================================");
  }

  @override
  void part2() {
    // what's the chance that 5+ robots are horizontally aligned?
    // ... ok, then 10+?
    var robots = moveOnce(_robots);

    for (int i = 0; i < xmax * ymax; i++) {
      Map<num, List<Vector>> lines = {};

      for (final r in robots) {
        lines[r.y] = (lines[r.y] ?? [])..add(r);
      }

      for (final line in lines.values) {
        final Set<num> xs = Set.from(line.map((l) => l.x));
        final xsa = xs.toList()..sort((x1, x2) => (x1 - x2).toInt());
        int aligned = 0;

        for (int j = 1; j < xsa.length; j++) {
          if ((xsa[j] - xsa[j - 1]) < 2) {
            aligned++;
            if (aligned == 10) {
              print("(i = ${i + 1})");
              show(robots);
              return;
            }
          } else {
            aligned = 0;
          }
        }
      }

      robots = moveOnce(robots);
    }
  }
}
