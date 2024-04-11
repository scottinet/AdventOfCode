import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:aoc2015/grid_point.dart';
import 'package:aoc2015/runnable.dart';
import 'package:collection/collection.dart';

class Y2015Day18 implements Runnable {
  final List<GridPoint<int>> _lights = [];
  int xmax = 0;
  int ymax = 0;

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    ymax = lines.length;
    xmax = lines[0].length;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        _lights.add(GridPoint(
            x: x,
            y: y,
            value: lines[y][x] == '#' ? 1 : 0,
            ymin: 0,
            ymax: ymax,
            xmin: 0,
            xmax: xmax));
      }
    }
  }

  void printLights(List<GridPoint<int>> lights) {
    Map<String, GridPoint<int>> mlights = {
      for (var l in lights) l.toString(): l
    };

    for (int y = 0; y < ymax; y++) {
      String lstr = '';

      for (int x = 0; x < xmax; x++) {
        final l = mlights[Point(x, y).toString()];

        if (l == null) {
          throw Exception('Point($x, $y) cannot be found but was expected');
        }

        lstr += l.value == 0 ? '.' : '#';
      }

      print(lstr);
    }
  }

  @override
  FutureOr<void> part1() {
    final steps = 100;
    Map<String, GridPoint<int>> lights = {
      for (var l in _lights) l.toString(): l
    };

    for (int i = 0; i < steps; i++) {
      Map<String, GridPoint<int>> l2 = {};

      for (final light in lights.values) {
        final litNeighbours = light.neighbours
            .map((n) => lights[n.toString()])
            .whereNotNull()
            .where((l) => l.value == 1)
            .length;
        int nval = light.value;

        if (nval == 1 && litNeighbours != 2 && litNeighbours != 3) {
          nval = 0;
        } else if (nval == 0 && litNeighbours == 3) {
          nval = 1;
        }

        final lnew = GridPoint<int>(
            x: light.x, y: light.y, value: nval, neighbours: light.neighbours);
        l2[lnew.toString()] = lnew;
      }

      lights = l2;
    }

    final onLights = lights.values.where((l) => l.value == 1).length;
    print('There are $onLights lights on.');
  }

  @override
  FutureOr<void> part2() {}
}
