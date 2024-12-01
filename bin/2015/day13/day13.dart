import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:advent_of_code/graphs/travelling_salesman.dart';
import 'package:advent_of_code/graphs/weighted_graph_node.dart';
import 'package:advent_of_code/runnable.dart';

class Y2015Day13 implements Runnable {
  final Map<String, WeightedGraphNode<String>> nodes = {};
  double withoutMeCost = 0;

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

  WeightedGraphNode<String> prepareForTSP() {
    // TSP finds the cheapiest route, we want the costliest one: we need to
    // invert the sign of weights.
    //
    // Also, TSP requires that all edge weights are symetrical
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

    return copy;
  }

  @override
  FutureOr<void> part1() {
    final copy = prepareForTSP();
    final path = travellingSalesman(copy);

    for (int i = 0; i < path.costs.length; i++) {
      print(
          "${path.path[i].data} -> ${path.path[i + 1].data} = ${-path.costs[i]}");
    }

    withoutMeCost =
        path.costs.fold<double>(0, (agg, val) => (-1.0 * val + agg));

    print("Cheapiest path: $withoutMeCost");
  }

  @override
  FutureOr<void> part2() {
    final copy = prepareForTSP();
    final me = WeightedGraphNode(data: "me");
    final queue = Queue<WeightedGraphNode<String>>.from([copy]);

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      if (me.children.containsKey(node)) continue;

      for (final c in node.children.keys) {
        if (me.children.containsKey(c)) continue;

        queue.add(c);
        me.children[c] = 0;
        c.children[me] = 0;
      }

      me.children[node] = 0;
      node.children[me] = 0;
    }

    final path = travellingSalesman(copy);

    for (int i = 0; i < path.costs.length; i++) {
      print(
          "${path.path[i].data} -> ${path.path[i + 1].data} = ${-path.costs[i]}");
    }

    double cost = path.costs.fold<double>(0, (agg, val) => (-1.0 * val + agg));

    print("Cheapiest path: $cost (diff with part 1: ${withoutMeCost - cost})");
  }
}
