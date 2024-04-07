import 'dart:async';
import 'dart:convert';
import 'package:aoc2015/runnable.dart';
import 'aunt_sue.dart';

class Y2015Day16 implements Runnable {
  final _aunts = <AuntSue>[];

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _aunts.addAll(lines.map((l) => AuntSue.from(l)));
  }

  @override
  FutureOr<void> part1() {
    final searched = <String, int>{
      "children": 3,
      "cats": 7,
      "samoyeds": 2,
      "pomeranians": 3,
      "akitas": 0,
      "vizslas": 0,
      "goldfish": 5,
      "trees": 3,
      "cars": 2,
      "perfumes": 1
    };

    final found = _aunts.firstWhere((aunt) => aunt.compounds.entries
        .every((entry) => searched[entry.key] == entry.value));

    print('Found aunt: ${found.number}');
  }

  @override
  FutureOr<void> part2() {}
}
