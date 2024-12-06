final class Vector {
  final int x;
  final int y;
  final int vx;
  final int vy;

  Vector({required (int, int) pos, required (int, int) dir})
      : x = pos.$1,
        y = pos.$2,
        vx = dir.$1,
        vy = dir.$2;

  Vector advance([int steps = 1]) {
    return Vector(pos: (x + steps * vx, y + steps * vy), dir: (vx, vy));
  }

  Vector changeDir((int, int) newDir) {
    return Vector(pos: pos, dir: newDir);
  }

  (int, int) get pos {
    return (x, y);
  }

  (int, int) get dir {
    return (vx, vy);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector &&
          runtimeType == other.runtimeType &&
          pos == other.pos &&
          dir == other.dir;

  @override
  int get hashCode => (x, y, vx, vy).hashCode;

  @override
  String toString() {
    return '($pos, $dir)';
  }
}
