import 'dart:async';

import 'package:aoc2015/runnable.dart';

class Y2015Day10 extends Runnable {
  final _groupRxp = RegExp(r'(.)\1*');
  String _content = "";

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    _content = await input.join();
  }

  String lookAndSay(String buf) {
    String result = "";
    final matches = _groupRxp.allMatches(buf);

    result = matches
        .map((match) => "${match.end - match.start}${buf[match.start]}")
        .join();

    return result;
  }

  @override
  void part1() {
    String buf = _content;

    for (int i = 0; i < 40; i++) {
      buf = lookAndSay(buf);
    }

    print("Result: ${buf.length}");
  }

  @override
  void part2() {
    String buf = _content;

    for (int i = 0; i < 50; i++) {
      buf = lookAndSay(buf);
    }

    print("Result: ${buf.length}");
  }
}
