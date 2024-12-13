/// The kind of neighbouring pattern:
///
/// - all (*): 8 potential neighbours (diagonals + orthogonals)
/// - cross (x): 4 potential neighbours (diagonals only)
/// - plus (+): 4 potential neighbours (orthogonals only)
enum NeighboursPattern { all, cross, plus }

class GridPoint<T> {
  final int x;
  final int y;
  final T value;
  final List<(int, int)> neighbours = [];

  GridPoint(
      {required this.x,
      required this.y,
      required this.value,
      int? xmin,
      int? xmax,
      int? ymin,
      int? ymax,
      List<(int, int)>? neighbours,
      NeighboursPattern pattern = NeighboursPattern.all}) {
    if (neighbours != null &&
        (xmin != null || xmax != null || ymin != null || ymax != null)) {
      throw Exception(
          'Incompatible arguments: neighbours cannot be set at the same time as xmin, xmax, ymin or ymax');
    }

    if (neighbours != null) {
      this.neighbours.addAll(neighbours.map((p) => (p.$1, p.$2)).toList());
    } else {
      for (int ny = y - 1; ny <= y + 1; ny++) {
        for (int nx = x - 1; nx <= x + 1; nx++) {
          if (nx == x && ny == y) continue;
          if (pattern == NeighboursPattern.plus && (nx - x) * (ny - y) != 0 ||
              pattern == NeighboursPattern.cross && (nx - x * ny - y) == 0) {
            continue;
          }

          if (xmin != null && nx < xmin || xmax != null && nx > xmax) continue;
          if (ymin != null && ny < ymin || ymax != null && ny > ymax) continue;

          this.neighbours.add((nx, ny));
        }
      }
    }
  }

  GridPoint<T> copy() {
    return GridPoint<T>(x: x, y: y, value: value, neighbours: neighbours);
  }

  bool isNeighbour(GridPoint p) {
    return neighbours.contains((p.x, p.y));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridPoint &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => (x, y).hashCode;

  @override
  String toString() {
    return '($x, $y)';
  }
}
