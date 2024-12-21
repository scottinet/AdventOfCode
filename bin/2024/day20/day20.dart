import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:advent_of_code/grid_point.dart';
import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

final class Y2024Day20 extends Runnable {
  late int _xmax, _ymax;
  final Map<(int, int), GridPoint<int>> _points = {};

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    late GridPoint<int> start, end;

    _ymax = lines.length;
    _xmax = lines[0].length;

    for (int y = 0; y < _ymax; y++) {
      for (int x = 0; x < _xmax; x++) {
        if (lines[y][x] == '#') continue;

        final p = toGridPoint((x, y), 0);

        _points[(x, y)] = p;

        if (lines[y][x] == 'S') {
          start = p;
        } else if (lines[y][x] == 'E') {
          end = p;
        }
      }
    }

    // optimization: store in the point value their path index
    GridPoint<int> prev = start;
    GridPoint<int> point = start;
    int steps = 0;

    while (point != end) {
      steps++;

      for (final n in point.neighbours) {
        if (n != prev.pos && _points.containsKey(n)) {
          prev = point;
          _points[n] = _points[n]!.copyWith(value: steps);
          point = _points[n]!;
          break;
        }
      }
    }
  }

  GridPoint<int> toGridPoint((int, int) pos, int value) {
    return GridPoint<int>(
        value: value,
        x: pos.$1,
        y: pos.$2,
        xmin: 0,
        ymin: 0,
        xmax: _xmax,
        ymax: _ymax,
        pattern: NeighboursPattern.plus);
  }

  Map<GridPoint<int>, int> pierce(GridPoint start, int depth) {
    Map<GridPoint<int>, int> exitPoints = {};
    Set<GridPoint<int>> piercable =
        Set.from(start.neighbours.map((p) => toGridPoint(p, 1)));

    for (int i = 1; i < depth; i++) {
      final tasks = piercable.toList();

      for (final p in tasks) {
        for (final pn in p.neighbours.map((n) => toGridPoint(n, i + 1))) {
          if (!piercable.contains(pn)) {
            piercable.add(pn);
          }
        }
      }
    }

    for (final pierced in piercable) {
      for (final pn in pierced.neighbours) {
        final point = _points[pn];
        if (point == null || point.value <= start.value) continue;

        final saves = (point.value - start.value) - (pierced.value + 1);

        if (saves > 0) {
          final prev = exitPoints[point];
          exitPoints[point] =
              prev != null ? max(prev, saves.toInt()) : saves.toInt();
        }
      }
    }

    return exitPoints;
  }

  @override
  void part1() {
    const int threshold = 100;
    int cheats = 0;

    for (final p in _points.values) {
      final holes = pierce(p, 1);
      cheats += holes.values.where((v) => v >= threshold).length;
    }

    print("There are $cheats cheats with a gain over $threshold");
  }

  @override
  void part2() {
    const int threshold = 100;
    Map<int, int> cheats = {};

    for (final p in _points.values) {
      final holes = pierce(p, 19);

      for (final h in holes.values.where((v) => v >= threshold)) {
        cheats[h] = (cheats[h] ?? 0) + 1;
      }
    }

    int total = 0;

    for (final cheat in cheats.entries.sorted((a, b) => a.key - b.key)) {
      // print(
      //     "There are ${cheat.value} cheats that save ${cheat.key} picoseconds");
      total += cheat.value;
    }

    print("\n=> There are $total cheats in total");
  }
}
