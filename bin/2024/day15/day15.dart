import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:advent_of_code/vector.dart';

typedef Block = ({(num, num) pos, String kind});

final class Y2024Day15 extends Runnable {
  final Map<(int, int), String> _map = {};
  final List<(int, int)> _directions = [];
  late (num, num) _robot;
  int xmax = -1, ymax = -1;

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    xmax = lines[0].length;

    for (int y = 0; y < lines.length; y++) {
      if (ymax == -1 && lines[y].isEmpty) {
        ymax = y;
      }

      for (int x = 0; x < lines[y].length; x++) {
        switch (lines[y][x]) {
          case '.':
            continue;
          case '#':
          case 'O':
            _map[(x, y)] = lines[y][x];
            break;
          case '@':
            _robot = (x, y);
            break;
          case '^':
            _directions.add((0, -1));
            break;
          case '>':
            _directions.add((1, 0));
            break;
          case 'v':
            _directions.add((0, 1));
            break;
          case '<':
            _directions.add((-1, 0));
            break;
          default:
            throw Exception("Don't know what to do with char ${lines[y][x]}");
        }
      }
    }
  }

  @override
  void part1() {
    final map = Map<(int, int), String>.from(_map);
    var robot = _robot;

    for (final dir in _directions) {
      var vect = Vector(pos: robot, dir: dir);
      int moves = 1;
      for (; map[vect.advance(moves).pos] == 'O'; moves++) {}

      if (map[vect.advance(moves).pos] == '#') continue;

      robot = vect.advance(1).pos;

      for (int i = moves; i > 1; i--) {
        final spot = vect.advance(i - 1);
        map.remove(spot.pos);
        map[vect.advance(i).pos as (int, int)] = 'O';
      }
    }

    print("Sum of GPS coordinates: ${getGpsCoords(map)}");
  }

  int getGpsCoords(Map<(int, int), String> map) {
    return map.entries.fold(
        0,
        (agg, spot) =>
            agg + (spot.value == 'O' ? spot.key.$1 + 100 * spot.key.$2 : 0));
  }

  Block? getBlockAt(Map<(int, int), String> map, (num, num) pos) {
    Block? block;

    if (map.containsKey(pos)) {
      block = (pos: pos, kind: map[pos]!);
    } else if (map[(pos.$1 - 1, pos.$2)] == 'O') {
      block = (pos: (pos.$1 - 1, pos.$2), kind: 'O');
    }

    return block;
  }

  bool push(
      {required Map<(int, int), String> map,
      required Block block,
      required (num, num) dir,
      required bool doIt}) {
    if (block.kind == '#') return false;

    final wide = block.kind == 'O' ? 2 : 1;
    final Set<Block> next = {};

    for (int i = 0; i < wide; i++) {
      final vect = Vector(pos: (block.pos.$1 + i, block.pos.$2), dir: dir);
      final b = getBlockAt(map, vect.advance().pos);

      if (b != null && b.pos != block.pos) next.add(b);
    }

    final canPush = next.isEmpty ||
        next.toList().fold(
            true,
            (agg, val) =>
                agg && push(map: map, block: val, dir: dir, doIt: doIt));

    if (!canPush) return false;

    if (doIt && block.kind == 'O') {
      map.remove(block.pos);
      map[Vector(pos: block.pos, dir: dir).advance().pos as (int, int)] =
          block.kind;
    }

    return true;
  }

  @override
  void part2() {
    var robot = (_robot.$1 * 2, _robot.$2);
    final Map<(int, int), String> map = {};

    for (final entry in _map.entries) {
      map[(entry.key.$1 * 2, entry.key.$2)] = entry.value;

      if (entry.value == '#') {
        map[(entry.key.$1 * 2 + 1, entry.key.$2)] = entry.value;
      }
    }

    for (final dir in _directions) {
      final vect = Vector(pos: robot, dir: dir);
      final block = getBlockAt(map, vect.advance().pos);

      if (block == null) {
        robot = vect.advance().pos;
      } else if (push(map: map, block: block, dir: dir, doIt: false)) {
        push(map: map, block: block, dir: dir, doIt: true);
        robot = vect.advance(1).pos;
      }
    }

    print("Sum of GPS coordinates: ${getGpsCoords(map)}");
  }
}
