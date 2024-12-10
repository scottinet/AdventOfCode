import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/graphs/travelling_salesman.dart';
import 'package:advent_of_code/runnable.dart';

typedef Block = ({int id, int len});

final class Y2024Day09 extends Runnable {
  List<Block> blocks = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final line =
        (await input.transform(LineSplitter()).toList()).first.split('');
    int id = -1;

    for (int i = 0; i < line.length; i++) {
      int n = int.parse(line[i]);

      if (i % 2 == 0) {
        id++;
        blocks.add((id: id, len: n));
      } else if (n > 0) {
        blocks.add((id: -1, len: n));
      }
    }
  }

  Block removeLast(List<Block> list) {
    Block removed = list.removeLast();

    while (removed.id == -1) {
      removed = list.removeLast();
    }

    return removed;
  }

  int computeChecksum(List<Block> blocks) {
    int checksum = 0;
    int pos = 0;

    for (final block in blocks) {
      if (block.id == -1) {
        pos += block.len;
        continue;
      }

      final max = pos + block.len;
      for (; pos < max; pos++) {
        checksum += block.id * pos;
      }
    }

    return checksum;
  }

  @override
  void part1() {
    final copy = List<Block>.from(blocks);
    Block moved = removeLast(copy);

    for (int i = 0; i < copy.length; i++) {
      if (copy[i].id != -1) continue;

      int diff = copy[i].len - moved.len;

      if (diff == 0) {
        copy[i] = moved;
        moved = removeLast(copy);
      } else if (diff < 0) {
        copy[i] = (id: moved.id, len: copy[i].len);
        moved = (id: moved.id, len: moved.len - copy[i].len);
      } else {
        copy.insert(i, moved);
        copy[i + 1] = (id: -1, len: copy[i + 1].len - moved.len);
        moved = removeLast(copy);
      }
    }

    copy.add(moved);

    print("Checksum: ${computeChecksum(copy)}");
  }

  @override
  void part2() {
    final copy = List<Block>.from(blocks);
    int id = -1 >>> 1;

    while (true) {
      final idx = copy.lastIndexWhere((blk) => blk.id > -1 && blk.id < id);

      if (idx == -1) break;

      id = copy[idx].id;
      final freeIdx =
          copy.indexWhere((blk) => blk.id == -1 && blk.len >= copy[idx].len);

      if (freeIdx == -1 || freeIdx > idx) continue;

      final moved = copy.removeAt(idx);
      final diff = copy[freeIdx].len - moved.len;

      copy.insert(idx, (id: -1, len: moved.len));
      copy[freeIdx] = moved;

      if (diff > 0) {
        copy.insert(freeIdx + 1, (id: -1, len: diff));
      }
    }

    print("Checksum: ${computeChecksum(copy)}");
  }
}
