import 'dart:convert';
import 'dart:async';
import 'package:aoc2015/runnable.dart';
import 'package:trotter/trotter.dart';

class Y2015Day17 implements Runnable {
  final containers = <int>[];

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    containers.addAll(lines.map((l) => int.parse(l)));
  }

  @override
  FutureOr<void> part1() {
    int matches = 0;
    final indexes = List<int>.generate(containers.length, (i) => i);
    final subsets = Subsets(indexes);

    print('${subsets.length} subsets');
    for (final subset in subsets()) {
      if (subset.fold(0, (value, element) => value + containers[element]) ==
          150) {
        matches++;
      }
    }

    print('There are $matches combinations of containers');
  }

  @override
  FutureOr<void> part2() {}
}
