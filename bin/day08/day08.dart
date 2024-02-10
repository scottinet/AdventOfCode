import 'dart:async';
import 'dart:convert';

import 'package:aoc2015/models/runnable.model.dart';

class Day08 extends Runnable {
  List<String> lines = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    lines = await input.transform(LineSplitter()).toList();
  }

  @override
  void part1() {
    const escapable = ['x', '\\', '"'];
    int total = 0;
    int unescaped = 0;

    for (final line in lines) {
      total += line.length;
      List<String> split = line.split('');
      int strlen = 0;

      for (int i = 0; i < line.length; i++) {
        if (split[i] == '\\' && escapable.contains(split[i + 1])) {
          if (split[i + 1] == 'x') {
            strlen++;
            i += 3;
          } else {
            strlen++;
            i++;
          }
        } else if (split[i] != '"') {
          strlen++;
        }
      }

      unescaped += strlen;
    }

    print('Difference: ${total - unescaped}');
  }

  @override
  void part2() {}
}
