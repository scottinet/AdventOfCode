import 'dart:collection';

class WeightedGraphNode<T> {
  T data;
  Map<WeightedGraphNode<T>, double> children = {};

  WeightedGraphNode({required this.data});

  void linkTo(WeightedGraphNode<T> node, double weight) {
    this.children[node] = weight;

    if (!node.children.containsKey(this)) {
      node.children[this] = weight;
    }
  }

  WeightedGraphNode<T> deepCopy() {
    final queue = Queue<WeightedGraphNode<T>>.from([this]);
    final copy = WeightedGraphNode(data: data);
    final seen = {this: copy};

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      final nodeCopy = seen[node]!;

      for (final child in node.children.entries) {
        final childCopy = seen.putIfAbsent(child.key, () {
          queue.add(child.key);
          final c = WeightedGraphNode(data: child.key.data);
          return c;
        });

        nodeCopy.linkTo(childCopy, child.value);
      }
    }

    return copy;
  }
}
