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

    for (final subset in subsets()) {
      final sum = subset.fold(0, (agg, val) => agg + containers[val]);

      if (sum == 150) {
        matches++;
      }
    }

    print('There are $matches combinations of containers');
  }

  @override
  FutureOr<void> part2() {
    int matches = 0;
    int containersCount = containers.length;
    final indexes = List<int>.generate(containers.length, (i) => i);
    final subsets = Subsets(indexes);

    for (final subset in subsets()) {
      if (subset.length > containersCount) continue;
      final sum = subset.fold(0, (agg, val) => agg + containers[val]);

      if (sum == 150) {
        if (subset.length == containersCount) {
          matches++;
        } else {
          matches = 1;
          containersCount = subset.length;
        }
      }
    }

    print('There are $matches combinations of $containersCount containers');
  }
}
