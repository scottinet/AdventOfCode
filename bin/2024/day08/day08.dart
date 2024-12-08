import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:trotter/trotter.dart';

typedef Point = ({int x, int y});

final class Y2024Day08 extends Runnable {
  final Map<String, List<Point>> antennas = {};
  Point limit = (x: -1, y: -1);

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    limit = (x: lines[0].length, y: lines.length);

    for (int y = 0; y < limit.y; y++) {
      for (int x = 0; x < limit.x; x++) {
        final value = lines[y][x];

        if (value != '.') {
          antennas[value] ??= [];
          antennas[value]!.add((x: x, y: y));
        }
      }
    }
  }

  bool _isWithinLimits(Point p) {
    return p.x >= 0 && p.x < limit.x && p.y >= 0 && p.y < limit.y;
  }

  @override
  void part1() {
    Set<Point> antinodes = {};

    for (final MapEntry(value: posList) in antennas.entries) {
      final pairs = Combinations(2, posList);

      for (final [antA, antB] in pairs()) {
        final Point diff = (x: antA.x - antB.x, y: antA.y - antB.y);
        // given how the parsing is done, antennas are already sorted after
        // their Y-axis
        antinodes.addAll([
          (x: antA.x + diff.x, y: antA.y + diff.y),
          (x: antB.x - diff.x, y: antB.y - diff.y)
        ]);
      }
    }

    final count = antinodes.where(_isWithinLimits).length;
    print("There are $count antinodes");
  }

  @override
  void part2() {
    Set<Point> antinodes = {};

    for (final MapEntry(value: posList) in antennas.entries) {
      final pairs = Combinations(2, posList);

      for (final [antA, antB] in pairs()) {
        final Point diff = (x: antA.x - antB.x, y: antA.y - antB.y);
        Point next = antA;
        do {
          antinodes.add(next);
          next = (x: next.x + diff.x, y: next.y + diff.y);
        } while (_isWithinLimits(next));

        next = antA;
        do {
          antinodes.add(next);
          next = (x: next.x - diff.x, y: next.y - diff.y);
        } while (_isWithinLimits(next));
      }
    }

    print("There are ${antinodes.length} antinodes");
  }
}
