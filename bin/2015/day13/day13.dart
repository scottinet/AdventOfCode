import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:aoc2015/graphs/travelling_salesman.dart';
import 'package:aoc2015/graphs/weighted_graph_node.dart';
import 'package:aoc2015/runnable.dart';

class Y2015Day13 implements Runnable {
  final Map<String, WeightedGraphNode<String>> nodes = {};

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final rxp = RegExp(
        r'^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\.$');
    final lines = await input.transform(LineSplitter()).toList();

    for (final line in lines) {
      final [start, dir, weight, end] =
          rxp.firstMatch(line)!.groups([1, 2, 3, 4]);

      final startNode = nodes[start] ?? WeightedGraphNode(data: start!);
      final endNode = nodes[end] ?? WeightedGraphNode(data: end!);
      final sign = dir == "gain" ? 1 : -1;

      startNode.linkTo(endNode, sign * double.parse(weight!));
      nodes[start!] = startNode;
      nodes[end!] = endNode;
    }
  }

  @override
  FutureOr<void> part1() {
    // Priciest route: we need to invert the sign of weights.
    // Travelling Salesman: all edge weights must be symetrical
    final copy = nodes.values.first.deepCopy();
    final seen = <WeightedGraphNode<String>>{};
    final queue = Queue<WeightedGraphNode<String>>.from([copy]);

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();

      if (seen.contains(node)) continue;

      seen.add(node);

      for (final child in node.children.entries) {
        if (seen.contains(child.key)) continue;
        queue.add(child.key);
        final w = -1 * (child.value + child.key.children[node]!);
        node.children[child.key] = w;
        child.key.children[node] = w;
      }
    }

    final path = travellingSalesman(copy);

    for (int i = 0; i < path.costs.length; i++) {
      print(
          "${path.path[i].data} -> ${path.path[i + 1].data} = ${-path.costs[i]}");
    }

    print(
        "Cheapiest path: ${path.costs.fold<double>(0, (agg, val) => (-1.0 * val + agg))}");
  }

  @override
  FutureOr<void> part2() {}
}
