import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

import 'weighted_graph_node.dart';

typedef G = Map<String, Map<int, double>>;

class TravellingSalesmanResult {
  final List<WeightedGraphNode> path;
  final List<double> costs;

  TravellingSalesmanResult({required this.path, required this.costs});

  double get totalCost => costs.reduce((a, b) => a + b);
}

/// Solves the travelling salesman problem for a given graph.
///
/// Uses the Held-Karp algorithm to solve the problem.
///
/// The graph is represented by a starting [WeightedGraphNode] with weighted
/// edges.
///
/// The optional parameter [includeReturnToStartDistance] determines whether
/// the distance from the last city back to the starting city should be included
/// in the result. The default is `true`.
TravellingSalesmanResult travellingSalesman(WeightedGraphNode start) {
  final cities = _citiesFromGraph(start);
  final g = heldKarp(cities);

  return buildResult(g, cities);
}

List<WeightedGraphNode> _citiesFromGraph(WeightedGraphNode start) {
  final cities = <WeightedGraphNode>{start};
  final queue = start.children.keys.toList();

  while (queue.isNotEmpty) {
    final node = queue.removeLast();
    cities.add(node);

    for (final child in node.children.keys) {
      if (!cities.contains(child)) {
        cities.add(child);
        queue.add(child);
      }
    }
  }

  return cities.toList();
}

String listToKey(List<int> list) => (list..sort()).join(',');

G heldKarp(List<WeightedGraphNode> cities) {
  final start = cities[0];
  final startlessCities =
      Iterable<int>.generate(cities.length).toList().slice(1);
  final G g = {};

  for (int k = 1; k < cities.length; k++) {
    final city = cities[k];
    g[listToKey([k])] = {k: start.children[city] ?? double.infinity};
  }

  for (int s = 2; s < cities.length; s++) {
    final sets = Combinations(s, startlessCities);

    for (final set in sets()) {
      final key = listToKey(set);
      g[key] ??= {};

      for (final k in set) {
        final klessSet = List<int>.from(set)..remove(k);
        final subsets = g[listToKey(klessSet)]!;
        double min = double.infinity;

        for (final m in klessSet) {
          final value =
              subsets[m]! + (cities[m].children[cities[k]] ?? double.infinity);
          if (value < min) min = value;
        }

        g[key]![k] = min;
      }
    }
  }

  return g;
}

TravellingSalesmanResult buildResult(G g, List<WeightedGraphNode> cities) {
  final start = cities[0];
  final startlessCities =
      Iterable<int>.generate(cities.length).toList().slice(1);
  final subsets = g[listToKey(startlessCities)]!;
  double min = double.infinity;
  int prev = -1;

  for (final m in startlessCities) {
    final value = subsets[m]! + (cities[m].children[start] ?? double.infinity);
    if (value < min) {
      min = value;
      prev = m;
    }
  }

  final path = [0, prev];
  final costs = [cities[0].children[cities[prev]] ?? double.infinity];
  var set = List<int>.from(startlessCities)..remove(prev);

  while (set.isNotEmpty) {
    final subsets = g[listToKey(set)]!;
    final current = prev;
    double min = double.infinity;

    for (final m in set) {
      final cost = cities[m].children[cities[current]] ?? double.infinity;
      final value = subsets[m]! + cost;
      if (value < min) {
        min = value;
        prev = m;
      }
    }

    path.add(prev);
    costs.add(cities[current].children[cities[prev]] ?? double.infinity);
    set.remove(prev);
  }

  path.add(0);
  costs.add(cities[prev].children[start] ?? double.infinity);

  return TravellingSalesmanResult(
      path: path.map((i) => cities[i]).toList(), costs: costs);
}
