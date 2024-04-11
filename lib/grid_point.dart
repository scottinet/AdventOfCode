import 'dart:math';

import 'package:equatable/equatable.dart';

class GridPoint<T> extends Point<int> implements Equatable {
  final T value;
  final List<Point<int>> neighbours = [];

  GridPoint(
      {required int x,
      required int y,
      required this.value,
      int? xmin,
      int? xmax,
      int? ymin,
      int? ymax,
      List<Point<int>>? neighbours})
      : super(x, y) {
    if (neighbours != null &&
        (xmin != null || xmax != null || ymin != null || ymax != null)) {
      throw Exception(
          'Incompatible arguments: neighbours cannot be set at the same time as xmin, xmax, ymin or ymax');
    }

    if (neighbours != null) {
      this.neighbours.addAll(neighbours.map((p) => Point(p.x, p.y)).toList());
    } else {
      for (int ny = y - 1; ny <= y + 1; ny++) {
        for (int nx = x - 1; nx <= x + 1; nx++) {
          if (nx == x && ny == y) continue;
          if (xmin != null && nx < xmin || xmax != null && nx > xmax) continue;
          if (ymin != null && ny < ymin || ymax != null && ny > ymax) continue;

          this.neighbours.add(Point(nx, ny));
        }
      }
    }
  }

  GridPoint<T> copy() {
    return GridPoint<T>(x: x, y: y, value: value, neighbours: neighbours);
  }

  @override
  List<Object?> get props => [x, y];

  @override
  bool? get stringify => true;
}
