import 'dart:async';
import 'dart:convert';
import 'package:advent_of_code/runnable.dart';
import 'aunt_sue.dart';

class Y2015Day16 implements Runnable {
  final _aunts = <AuntSue>[];
  final mfcsamOutput = <String, int>{
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

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _aunts.addAll(lines.map((l) => AuntSue.from(l)));
  }

  @override
  FutureOr<void> part1() {
    final found = _aunts.firstWhere((aunt) => aunt.compounds.entries
        .every((entry) => mfcsamOutput[entry.key] == entry.value));

    print('Found aunt: ${found.number}');
  }

  @override
  FutureOr<void> part2() {
    for (final aunt in _aunts) {
      bool matched = true;

      for (final MapEntry(key: compound, value: qty) in mfcsamOutput.entries) {
        final searchedQty = aunt.compounds[compound];

        switch (compound) {
          case 'cats':
          case 'trees':
            matched = searchedQty == null || searchedQty > qty;
            break;
          case 'pomeranians':
          case 'goldfish':
            matched = searchedQty == null || searchedQty < qty;
            break;
          default:
            matched = searchedQty == null || searchedQty == qty;
        }

        if (!matched) break;
      }

      if (matched) {
        print('Found aunt: ${aunt.number}');
      }
    }
  }
}
