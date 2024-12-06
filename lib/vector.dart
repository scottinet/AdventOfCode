final class Vector {
  final num x;
  final num y;
  final num vx;
  final num vy;

  Vector({required (num, num) pos, required (num, num) dir})
      : x = pos.$1,
        y = pos.$2,
        vx = dir.$1,
        vy = dir.$2;

  Vector advance([int steps = 1]) {
    return Vector(pos: (x + steps * vx, y + steps * vy), dir: (vx, vy));
  }

  Vector changeDir((num, num) newDir) {
    return Vector(pos: pos, dir: newDir);
  }

  (num, num) get pos {
    return (x, y);
  }

  (num, num) get dir {
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
