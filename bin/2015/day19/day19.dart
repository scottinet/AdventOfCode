import 'dart:convert';
import 'dart:async';
import 'package:aoc2015/runnable.dart';
import 'package:collection/collection.dart';

class Y2015Day19 implements Runnable {
  String _molecule = '';
  final Map<String, List<String>> _replacements = {};

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    final lines = await input.transform(LineSplitter()).toList();
    final matcher = RegExp(r'(\w+) => (\w+)');

    for (String line in lines.where((l) => l.isNotEmpty)) {
      final matches = matcher.allMatches(line);

      if (matches.isNotEmpty) {
        final [src, dest] = matches.first.groups([1, 2]);

        _replacements[src!] ??= [];
        _replacements[src]!.add(dest!);
      } else {
        _molecule = line;
      }
    }
  }

  @override
  FutureOr<void> part1() {
    final Set<String> molecules = {};

    for (final MapEntry(key: src, value: dests) in _replacements.entries) {
      for (final match in src.allMatches(_molecule)) {
        for (final dest in dests) {
          molecules.add(_molecule.replaceFirst(src, dest, match.start));
        }
      }
    }

    print("There are ${molecules.length} unique molecules");
  }

  @override
  FutureOr<void> part2() {}
}
