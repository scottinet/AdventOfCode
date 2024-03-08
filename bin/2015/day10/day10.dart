import 'dart:async';

import 'package:aoc2015/runnable.dart';

class Y2015Day10 extends Runnable {
  String content = "";

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    content = await input.join();
  }

  @override
  void part1() {
    String buf = content;
    String next = "";

    for (int i = 0; i < 40; i++) {
      int count = 0;

      for (int c = 0; c < buf.length; c++) {
        if (c == buf.length - 1 || buf[c] != buf[c + 1]) {
          next += (count + 1).toString() + buf[c];
          count = 0;
        } else {
          count++;
        }
      }

      buf = next;
      next = "";
    }

    print("Result: ${buf.length}");
  }

  @override
  void part2() {}
}
