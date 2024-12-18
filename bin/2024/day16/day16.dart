import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/grid_point.dart';
import 'package:advent_of_code/prority_queue.dart' as pq;
import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';
import 'package:collection/collection.dart';

final class Y2024Day16 extends Runnable {
  final Map<(int, int), GridPoint> _points = {};
  late GridPoint _start, _end;
  late int xmax, ymax;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    ymax = lines.length - 2;
    xmax = lines.length - 2;

    for (int y = 0; y < ymax; y++) {
      for (int x = 0; x < xmax; x++) {
        final char = lines[y + 1][x + 1];

        if (char == '#') continue;
        final p = GridPoint(
            x: x,
            y: y,
            xmax: xmax,
            ymax: ymax,
            value: '.',
            pattern: NeighboursPattern.plus);

        _points[(x, y)] = p;
        if (char == 'E') {
          _end = p;
        } else if (char == 'S') {
          _start = p;
        }
      }
    }
  }

  /// custom-copy of shortest_path.dart
  /// dijsktra pathfinding algorithm adapted to Vectors to calculate weights
  /// depending on the current direction the reindeer is facing.
  (Map<Vector, double> distances, Map<Vector, List<Vector>> paths)
      findShortestPath() {
    final start = Vector(pos: _start.pos, dir: (1, 0));
    final distances = {start: 0.0};
    final queue = pq.PriorityQueue<Vector>();
    final prev = <Vector, List<Vector>>{};

    queue.add(Vector(pos: _start.pos, dir: (1, 0)), 0);

    while (queue.isNotEmpty) {
      final (uvect, _) = queue.removeFirst();

      if (uvect.pos == _end.pos) break;

      final upoint = _points[uvect.pos]!;

      for (final next
          in upoint.neighbours.where((p) => _points.containsKey(p))) {
        final vpoint = _points[next]!;
        final vvect = Vector(
            pos: vpoint.pos, dir: (vpoint.x - upoint.x, vpoint.y - vpoint.y));
        final seen = distances[vvect] != null;
        final vdist = distances[uvect]! + (vvect.dir == uvect.dir ? 1 : 1001);

        if (vdist <= (distances[vvect] ?? double.infinity)) {
          if (vdist < (distances[vvect] ?? double.infinity)) {
            distances[vvect] = vdist;
            prev[vvect] = [uvect];

            if (seen) {
              queue.decreasePriority(vvect, vdist);
            } else {
              queue.add(vvect, vdist);
            }
          } else {
            prev[vvect] = (prev[vvect] ?? [])..add(uvect);
          }
        }
      }
    }

    return (distances, prev);
  }

  @override
  void part1() {
    final result = findShortestPath();

    print(result.$1.entries.where((e) => e.key.pos == _end.pos));
  }

  @override
  void part2() {
    final result = findShortestPath();
    List<Vector> tasks = [...result.$2.keys.where((k) => k.pos == _end.pos)];
    Set<(num, num)> points = {_end.pos};

    while (tasks.isNotEmpty) {
      final task = tasks.removeAt(0);

      final prev = result.$2.entries
          .where((e) => e.key == task)
          .map((e) => e.value)
          .flattened;
      points.addAll(prev.map((p) => p.pos));

      tasks.addAll(prev);
    }

    print("Count: ${points.length}");
  }
}
