import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/graphs/weighted_graph_node.dart';
import 'package:advent_of_code/runnable.dart';

typedef Node = WeightedGraphNode<String>;

final class Y2024Day23 extends Runnable {
  final Map<String, Node> _computers = {};

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    for (final [a, b] in lines.map((l) => l.split('-'))) {
      final nodeA = _computers[a] ?? Node(data: a);
      final nodeB = _computers[b] ?? Node(data: b);

      nodeA.linkTo(nodeB, 1);

      _computers[a] ??= nodeA;
      _computers[b] ??= nodeB;
    }
  }

  @override
  void part1() {
    final candidates = _computers.values.where((k) => k.data.startsWith('t'));
    final Set<String> setOf3 = {};

    for (final computer in candidates) {
      for (final child in computer.children.keys) {
        child.children.keys
            .where((k) => k != computer && computer.children.containsKey(k))
            .forEach((c) {
          final set = [computer.data, child.data, c.data]..sort();
          setOf3.add(set.join('-'));
        });
      }
    }

    print("There are ${setOf3.length} LANs");
  }

  List<String> visit(Node start, Set<Node> visited) {
    final children = start.children.keys.where((c) =>
        !visited.contains(c) &&
        visited.every((v) => c.children.containsKey(v)));
    visited.add(start);

    if (children.isEmpty) return [start.data];

    List<String> longest = [];

    for (final child in children) {
      final result = visit(child, visited);
      longest = longest.length > result.length ? longest : result;
    }

    return longest..add(start.data);
  }

  @override
  void part2() {
    List<String> largerSet = [];

    for (final computer in _computers.values) {
      final result = visit(computer, {});
      largerSet = largerSet.length > result.length ? largerSet : result
        ..sort();
    }

    print("Password: ${largerSet.join(",")}");
  }
}
