import 'dart:async';

import 'package:advent_of_code/runnable.dart';
import 'package:crypto/crypto.dart';

class Y2015Day04 extends Runnable {
  String _md5prefix = '';

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    _md5prefix = await input.join();
  }

  @override
  void part1() {
    int i = 10;
    while (true) {
      var hash = md5.convert('$_md5prefix$i'.codeUnits).toString();
      if (hash.startsWith('00000')) {
        print('Part 1: $i');
        break;
      }
      i++;
    }
  }

  @override
  void part2() {
    // Welp, brute force it is. Less than 10s, so it's fine.
    int i = 10;
    while (true) {
      var hash = md5.convert('$_md5prefix$i'.codeUnits).toString();
      if (hash.startsWith('000000')) {
        print('Part 1: $i');
        break;
      }
      i++;
    }
  }
}
