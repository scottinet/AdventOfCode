import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aoc2015/graphs/weighted_graph_node.dart';
import 'package:aoc2015/runnable.dart';
import 'package:trotter/trotter.dart';

class Day09 extends Runnable {
  final Map<String, WeightedGraphNode<String>> nodes = {};

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final rxp = RegExp(r'^(\w+) to (\w+) = (\d+)$');
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      final [start, end, dist] = rxp.firstMatch(line)!.groups([1, 2, 3]);

      final startNode = nodes[start] ?? WeightedGraphNode(data: start!);
      final endNode = nodes[end] ?? WeightedGraphNode(data: end!);
      startNode.linkTo(endNode, double.parse(dist!));
      nodes[start!] = startNode;
      nodes[end!] = endNode;
    }
  }

  @override
  void part1() {
    final locations = nodes.values.toList();
    final permutations = Permutations(locations.length, locations);
    double minCost = double.infinity;

    for (final perm in permutations()) {
      double cost = 0;

      for (int i = 0; i < perm.length - 1; i++) {
        cost += perm[i].children[perm[i + 1]]!;
      }

      minCost = min(cost, minCost);
    }

    print('Cheapiest route: $minCost');
  }

  @override
  void part2() {
    final locations = nodes.values.toList();
    final permutations = Permutations(locations.length, locations);
    double maxCost = -double.infinity;

    for (final perm in permutations()) {
      double cost = 0;

      for (int i = 0; i < perm.length - 1; i++) {
        cost += perm[i].children[perm[i + 1]]!;
      }

      maxCost = max(cost, maxCost);
    }

    print('Costliest route: $maxCost');
  }
}
