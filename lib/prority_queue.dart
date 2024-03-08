import 'dart:collection';

const precision = 10e-6;

class PriorityQueueNode<T> {
  double value;
  bool marked = false;
  PriorityQueueNode? parent;
  DoubleLinkedQueue<PriorityQueueNode> children = DoubleLinkedQueue();
  T data;

  PriorityQueueNode(this.value, this.data);
}

/// Fibonacci Heap
/// See https://www.cs.princeton.edu/~wayne/cs423/fibonacci/FibonacciHeapAlgorithm.html
class PriorityQueue<T> {
  PriorityQueueNode? _min;
  final DoubleLinkedQueue<PriorityQueueNode> _rooted = DoubleLinkedQueue();
  final _byData = <T, PriorityQueueNode<T>>{};
  int _size = 0;
  int _marked = 0;

  PriorityQueue();

  int get potential => _rooted.length + 2 * _marked;
  int get size => _size;
  double? get min => _min?.value;
  bool get isEmpty => _min == null;
  bool get isNotEmpty => _min != null;

  PriorityQueue add(T data, double value) {
    if (_byData[data] != null) {
      throw Exception('Cannot add node: data already exists');
    }

    var node = PriorityQueueNode(value, data);

    _rooted.add(node);
    _byData[data] = node;

    if (_min == null || node.value < _min!.value) {
      _min = node;
    }

    _size++;

    return this;
  }

  void remove(T data) {
    decreasePriority(data, double.negativeInfinity);
    removeFirst();
  }

  PriorityQueue merge(PriorityQueue<T> other) {
    _rooted.addAll(other._rooted);
    _byData.addAll(other._byData);

    if (_min == null || other._min != null && other._min!.value < _min!.value) {
      _min = other._min;
    }

    _size += other._size;

    return this;
  }

  (T, double) removeFirst() {
    if (_min == null) {
      throw Exception('Nothing to remove');
    }

    final min = _min;
    _rooted.remove(min);
    _byData.remove(min!.data);
    _size--;

    for (final child in min.children) {
      child.parent = null;
      _rooted.add(child);
    }

    _consolidate();

    return (min.data, min.value);
  }

  void _link(PriorityQueueNode parent, PriorityQueueNode child) {
    _rooted.remove(child);

    child.parent = parent;
    parent.children.add(child);
    child.marked = false;
  }

  void _consolidate() {
    var aSize = 64;
    final A = List<PriorityQueueNode?>.filled(aSize, null);

    for (var x in _rooted) {
      var d = x.children.length;

      while (A[d] != null) {
        var y = A[d]!;

        if (x.value > y.value) {
          final t = x;
          x = y;
          y = t;
        }

        _link(x, y);
        A[d] = null;
        d++;

        if (d >= aSize) {
          aSize *= 2;
          A.length = aSize;
        }
      }

      A[d] = x;
    }

    _min = null;
    _rooted.clear();
    for (final element in A) {
      if (element != null) {
        _rooted.add(element);

        if (_min == null || element.value < _min!.value) {
          _min = element;
        }
      }
    }
  }

  void _cut(PriorityQueueNode parent, PriorityQueueNode child) {
    parent.children.remove(child);
    _rooted.add(child);
    child.parent = null;
    child.marked = false;
  }

  void _cascadingCut(PriorityQueueNode node) {
    var parent = node.parent;

    if (parent != null) {
      if (!node.marked) {
        node.marked = true;
        _marked++;
      } else {
        _cut(parent, node);
        _cascadingCut(parent);
      }
    }
  }

  void decreasePriority(T data, double newValue) {
    final node = _byData[data];

    if (node == null) {
      throw Exception('Cannot decrease priority of unknown node');
    }

    if (node.value <= newValue) {
      throw Exception(
          'Cannot decrease key: source value (${node.value}) is inferior to the target value ($newValue)');
    }

    node.value = newValue;
    final parent = node.parent;

    if (parent != null && node.value < parent.value) {
      _cut(parent, node);
      _cascadingCut(parent);
    }

    if (_min == null || node.value < _min!.value) {
      _min = node;
    }
  }
}
