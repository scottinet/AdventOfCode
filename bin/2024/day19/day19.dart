import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/runnable.dart';
import 'package:collection/collection.dart';

final class Y2024Day19 extends Runnable {
  final List<String> _patterns = [];
  final List<String> _desired = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();

    _patterns.addAll(lines[0].split(',').map((l) => l.trim()));
    _desired.addAll(lines.slice(2));
  }

  int countPossibleDesigns(String design, Map<String, int> cache) {
    if (design.isEmpty) return 1;
    if (cache.containsKey(design)) return cache[design]!;

    final candidates = _patterns.where((d) => design.startsWith(d));
    final result = candidates.isEmpty
        ? 0
        : candidates
            .map((c) => countPossibleDesigns(design.substring(c.length), cache))
            .reduce((agg, val) => agg + val);

    cache[design] = result;
    return result;
  }

  @override
  void part1() {
    final Map<String, int> cache = {};
    final possibles = _desired
        .map((d) => countPossibleDesigns(d, cache))
        .where((p) => p > 0)
        .length;

    print("There are $possibles possibles designs");
  }

  @override
  void part2() {
    final Map<String, int> cache = {};
    final possibles = _desired
        .map((d) => countPossibleDesigns(d, cache))
        .reduce((agg, val) => agg + val);

    print("There are $possibles combinations of possibles designs");
  }
}
