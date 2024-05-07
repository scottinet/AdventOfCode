import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'package:aoc2015/runnable.dart';
import 'molecule_step.dart';

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
  FutureOr<void> part2() {
    final pending =
        Queue<MoleculeStep>.from([MoleculeStep(molecule: _molecule, step: 0)]);
    final seen = <String, int>{};
    final replacements = _sortReplacements();

    while (pending.isNotEmpty) {
      final item = pending.removeLast();
      final seenValue = seen[item.molecule];

      if (seenValue != null) {
        if (item.step < seenValue) seen[item.molecule] = item.step;
        continue;
      }

      seen[item.molecule] = item.step;

      for (final (dest, src) in replacements) {
        final target = item.molecule.replaceFirst(dest, src);

        if (target != item.molecule) {
          pending.add(MoleculeStep(molecule: target, step: item.step + 1));
        }
      }
    }

    print("Molecule found in ${seen['e'] ?? -1} steps");
  }

  List<(String, String)> _sortReplacements() {
    final list = <(String, String)>[];

    for (final MapEntry(key: src, value: dests) in _replacements.entries) {
      list.addAll(dests.map((d) => (d, src)));
    }

    list.sort((a, b) => a.$1.length - b.$1.length);

    return list;
  }

  FutureOr<void> part2_take1() {
    final pending =
        Queue<MoleculeStep>.from([MoleculeStep(molecule: _molecule, step: 0)]);
    final seen = <String, int>{};

    while (pending.isNotEmpty) {
      final item = pending.removeLast();
      final seenValue = seen[item.molecule];
      final nextStep = item.step + 1;

      if (seenValue != null) {
        if (item.step < seenValue) seen[item.molecule] = item.step;
        continue;
      }

      seen[item.molecule] = item.step;

      for (final MapEntry(key: src, value: dests) in _replacements.entries) {
        for (final dest in dests) {
          for (final match in dest.allMatches(item.molecule)) {
            final target = item.molecule.replaceFirst(dest, src, match.start);

            if (target == 'e') {
              print("Found e in $nextStep steps");
            }

            if (target.length < item.molecule.length) {
              pending.add(MoleculeStep(molecule: target, step: nextStep));
            }
          }
        }
      }
    }

    print("Molecule found in ${seen['e'] ?? -1} steps");
  }
}
