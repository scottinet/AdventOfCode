import 'package:advent_of_code/prority_queue.dart';

import 'weighted_graph_node.dart';

/// Find the shortest path between two nodes in a weighted graph.
/// Dijsktra algorithm w/ priority queue
/// Returns a map of distances and a map of previous nodes.
///
/// The distance map contains the shortest distance from the start node to each
/// node in the graph. The previous map contains the previous node in the shortest
/// path from the start node to each node in the graph.
///
/// The shortest path can be reconstructed by following the previous map from the
/// end node to the start node.
(
  Map<WeightedGraphNode, double> distances,
  Map<WeightedGraphNode, WeightedGraphNode> paths
) findShortestPath(WeightedGraphNode start, WeightedGraphNode end) {
  final distances = {start: 0.0};
  final queue = PriorityQueue<WeightedGraphNode>();
  final prev = <WeightedGraphNode, WeightedGraphNode>{};

  queue.add(start, 0);

  while (queue.isNotEmpty) {
    final (u, _) = queue.removeFirst();

    if (u == end) break;

    for (final MapEntry(key: v, value: weight) in u.children.entries) {
      final seen = distances[v] != null;
      final vdist = distances[u]! + weight;

      if (vdist < (distances[v] ?? double.infinity)) {
        distances[v] = vdist;
        prev[v] = u;

        if (seen) {
          queue.decreasePriority(v, vdist);
        } else {
          queue.add(v, vdist);
        }
      }
    }
  }

  return (distances, prev);
}
