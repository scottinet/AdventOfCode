import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/graphs/shortest_path.dart';
import 'package:advent_of_code/graphs/weighted_graph_node.dart';
import 'package:advent_of_code/grid_point.dart';
import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

const ymax = 70;
const xmax = 70;

final class Y2024Day18 extends Runnable {
  final List<(num, num)> _corrupted = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      final [x, y] = line.split(',').map((n) => int.parse(n)).toList();
      _corrupted.add((x, y));
    }
  }

  @override
  void part1() {
    const bytes = 1024;
    final corrupted = Set<(num, num)>.from(_corrupted.slice(0, bytes).toList());
    final start = WeightedGraphNode<GridPoint>(
        data: GridPoint(
            x: 0,
            y: 0,
            xmin: 0,
            ymin: 0,
            xmax: xmax,
            ymax: ymax,
            value: '.',
            pattern: NeighboursPattern.plus));
    final Map<(num, num), WeightedGraphNode<GridPoint>> visited = {
      start.data.pos: start
    };
    final List<WeightedGraphNode<GridPoint>> tasks = [start];

    while (tasks.isNotEmpty) {
      final task = tasks.removeAt(0);

      for (final n in task.data.neighbours) {
        if (corrupted.contains(n)) continue;

        if (visited.containsKey(n)) {
          task.linkTo(visited[n]!, 1);
          continue;
        }
        final node = WeightedGraphNode<GridPoint>(
            data: GridPoint(
                x: n.$1,
                y: n.$2,
                xmin: 0,
                xmax: xmax,
                ymin: 0,
                ymax: ymax,
                value: '.',
                pattern: NeighboursPattern.plus));
        visited[n] = node;
        tasks.add(node);
        node.linkTo(task, 1);
      }
    }

    final end = visited[(xmax, ymax)]!;
    final path = findShortestPath(start, end);
    print(path.$1[end]);
  }

  @override
  void part2() {
    for (int bytes = 1025; bytes < _corrupted.length; bytes++) {
      final corrupted =
          Set<(num, num)>.from(_corrupted.slice(0, bytes).toList());
      final start = GridPoint(
          x: 0,
          y: 0,
          xmin: 0,
          ymin: 0,
          xmax: xmax,
          ymax: ymax,
          value: '.',
          pattern: NeighboursPattern.plus);
      final Set<(num, num)> visited = {start.pos};
      final List<GridPoint> tasks = [start];

      while (tasks.isNotEmpty) {
        final task = tasks.removeAt(0);

        for (final n in task.neighbours) {
          if (corrupted.contains(n) || visited.contains(n)) continue;

          final next = GridPoint(
              x: n.$1,
              y: n.$2,
              xmin: 0,
              xmax: xmax,
              ymin: 0,
              ymax: ymax,
              value: '.',
              pattern: NeighboursPattern.plus);
          visited.add(next.pos);
          tasks.add(next);
        }
      }

      if (!visited.contains((xmax, ymax))) {
        print("If ${_corrupted[bytes - 1]} fall, the exit is blocked! RUN!!");
        break;
      }
    }
  }
}
