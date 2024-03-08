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
}
