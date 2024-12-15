import 'package:advent_of_code/vector.dart';
import 'package:collection/collection.dart';

// Describes a block of any shape
// Block's point should be contiguous
final class MovableBlock<T> {
  final bool movable;
  final List<(num x, num y)> points;
  final T value;

  const MovableBlock(
      {required this.points, required this.movable, required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovableBlock &&
          runtimeType == other.runtimeType &&
          points.length == other.points.length &&
          points.every((p) => other.points.contains(p));

  bool match((num, num) pos) {
    return points.contains(pos);
  }

  MovableBlock copy() {
    return MovableBlock(
        points: List.from(points), movable: movable, value: value);
  }

  void move((num, num) dir) {
    for (int i = 0; i < points.length; i++) {
      points[i] = (points[i].$1 + dir.$1, points[i].$2 + dir.$2);
    }
  }

  @override
  int get hashCode => points.hashCode;

  @override
  String toString() {
    return points.toString();
  }
}

/// Manage movable blocks in a 2D plan
final class MovableBlocksList {
  final List<MovableBlock> blocks = [];

  MovableBlocksList();

  MovableBlocksList copy() {
    final copied = MovableBlocksList();
    copied.blocks.addAll(blocks.map((b) => b.copy()));

    return copied;
  }

  void add(MovableBlock b) {
    blocks.add(b);
  }

  void removeAt((num, num) pos) {
    final index = blocks.indexWhere((b) => b.match(pos));

    if (index != -1) {
      blocks.removeAt(index);
    }
  }

  MovableBlock? getBlockAt((num, num) pos) {
    return blocks.firstWhereOrNull((b) => b.match(pos));
  }

  bool _move(MovableBlock block, (num, num) dir, bool doIt) {
    if (!block.movable) return false;

    final Set<MovableBlock> next = {};

    for (final p in block.points) {
      final vect = Vector(pos: p, dir: dir);
      final b = getBlockAt(vect.advance().pos);

      if (b != null && b != block) next.add(b);
    }

    final canPush = next.isEmpty ||
        next.toList().fold(true, (agg, val) => agg && _move(val, dir, doIt));

    if (!canPush) return false;

    if (doIt && block.movable) {
      block.move(dir);
    }

    return true;
  }

  /// Move a block using the provided direction. If other movable blocks are on
  /// the way, they will be moved too.
  /// Returns a boolean telling if anything has moved.
  bool move({required MovableBlock block, required (num, num) dir}) {
    if (_move(block, dir, false)) {
      _move(block, dir, true);
      return true;
    }

    return false;
  }

  /// Push blocks in cascade, using the provided vector.
  /// Returns a boolean telling if anything has moved.
  bool push({required Vector v}) {
    final next = v.advance();
    final block = getBlockAt(next.pos);

    if (block == null || !block.movable) return false;

    return move(block: block, dir: next.dir);
  }

  void show(int xmax, int ymax) {
    for (int y = 0; y < ymax; y++) {
      String str = '';

      for (int x = 0; x < xmax * 2; x++) {
        final b = getBlockAt((x, y));

        if (b == null) {
          str += '.';
        } else {
          str += b.movable ? '█' : 'X';
        }
      }

      print(str);
    }

    print('---');
  }
}
