import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/grid_point.dart';
import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';

final class Y2024Day20 extends Runnable {
  late int _xmax, _ymax;
  final Map<(int, int), GridPoint> _points = {};
  final List<GridPoint> _path = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    _ymax = lines.length;
    _xmax = lines[0].length;

    GridPoint? start, end;

    for (int y = 0; y < _ymax; y++) {
      for (int x = 0; x < _xmax; x++) {
        final char = lines[y][x];

        if (char == '#') continue;

        final p = GridPoint(
            value: char,
            x: x,
            y: y,
            xmin: 0,
            ymin: 0,
            xmax: _xmax,
            ymax: _ymax,
            pattern: NeighboursPattern.plus);

        _points[(x, y)] = p;

        if (char == 'S') {
          start = p;
        } else if (char == 'E') {
          end = p;
        }
      }
    }

    _path.add(start!);
    Set<(num, num)> visited = {start.pos};

    for (var p = start; p != end;) {
      for (final n in p.neighbours) {
        if (_points.containsKey(n) && !visited.contains(n)) {
          p = _points[n]!;
          _path.add(p);
          visited.add(n);
          continue;
        }
      }
    }
  }

  List<(GridPoint, int)> pierce(GridPoint p, int depth) {
    List<(GridPoint, int)> neighbours = [];
    List<(int, int)> piercable =
        p.neighbours.where((p) => !_points.containsKey(p)).toList();

    for (final pierced in piercable) {
      var vect =
          Vector(pos: pierced, dir: (pierced.$1 - p.x, pierced.$2 - p.y));

      for (int i = 0; i < depth; i++) {
        vect = vect.advance();
        if (_points.containsKey(vect.pos)) {
          neighbours.add((_points[vect.pos]!, i + 2));
          break;
        }
      }
    }

    return neighbours;
  }

  @override
  void part1() {
    int cheats = 0;

    for (final p in _path) {
      final idx1 = _path.indexOf(p);
      final holes = pierce(p, 2);

      for (final h in holes) {
        final saved = _path.indexOf(h.$1) - idx1 - h.$2;

        if (saved >= 100) {
          cheats++;
        }
      }
    }

    print("There are $cheats cheats");
  }

  @override
  void part2() {}
}
