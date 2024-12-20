import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/grid_point.dart';
import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

typedef Region = ({String name, List<GridPoint<String>> points});

final class Y2024Day12 extends Runnable {
  List<Region> regions = [];
  int ymax = -1;
  int xmax = -1;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    ymax = lines.length;
    xmax = lines[0].length;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        final point = GridPoint(
            x: x,
            y: y,
            value: lines[y][x],
            xmin: 0,
            xmax: xmax,
            ymin: 0,
            ymax: ymax,
            pattern: NeighboursPattern.plus);

        final List<int> indexes = [];
        for (int i = 0; i < regions.length; i++) {
          if (regions[i].name == point.value &&
              regions[i]
                      .points
                      .firstWhereOrNull((p) => p.isNeighbour(point.pos)) !=
                  null) {
            indexes.add(i);
          }
        }

        if (indexes.isEmpty) {
          regions.add((name: point.value, points: [point]));
        } else if (indexes.length == 1) {
          regions[indexes[0]].points.add(point);
        } else {
          for (int i = indexes.length - 1; i > 0; i--) {
            regions[indexes[0]]
                .points
                .addAll(regions.removeAt(indexes[i]).points);
          }
          regions[indexes[0]].points.add(point);
        }
      }
    }
  }

  @override
  void part1() {
    int price = 0;

    for (final r in regions) {
      int perimeter = 0;

      for (final p in r.points) {
        perimeter += 4 -
            p.neighbours.length +
            p.neighbours
                .where((n) =>
                    r.points.firstWhereOrNull(
                        (rp) => rp.x == n.$1 && rp.y == n.$2) ==
                    null)
                .length;
      }

      price += r.points.length * perimeter;
    }

    print("Total price: $price");
  }

  @override
  void part2() {
    int price = 0;

    for (final r in regions) {
      Map<String, List<int>> sides = {};

      for (final p in r.points) {
        final missing = GridPoint(
                x: p.x, y: p.y, value: p.value, pattern: NeighboursPattern.plus)
            .neighbours
            .where((n) =>
                r.points
                    .firstWhereOrNull((rp) => rp.x == n.$1 && rp.y == n.$2) ==
                null)
            .toList();

        for (final m in missing) {
          if (m.$1 != p.x) {
            final id = '${m.$1 < p.x ? 'W' : 'E'}${m.$1}';
            sides[id] ??= [];
            sides[id]!.add(p.y);
          } else {
            final id = '${m.$2 < p.y ? 'N' : 'S'}${m.$2}';
            sides[id] ??= [];
            sides[id]!.add(p.x);
          }
        }
      }

      int sidesCount = 0;

      for (final seq in sides.values) {
        seq.sort();
        sidesCount++;

        for (int i = 1; i < seq.length; i++) {
          if (seq[i] != seq[i - 1] + 1) sidesCount++;
        }
      }

      price += r.points.length * sidesCount;
    }

    print("Total price: $price");
  }
}
