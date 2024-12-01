import 'dart:convert';
import 'dart:io';

import 'package:advent_of_code/runnable.dart';

Map<String, Runnable> dayRunners = {};

void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart aoc2015.dart <day> <input file>');
    exit(1);
  }

  final runnable = dayRunners[args[0]];

  if (runnable == null) {
    print('Day ${args[0]} not found');
    exit(1);
  }

  final input = File('bin/2015/${args[0]}/data/${args[1]}')
      .openRead()
      .transform(utf8.decoder);

  await runnable.init(input);

  var stopwatch = Stopwatch()..start();
  await runnable.part1();
  stopwatch.stop();
  print('(part 1 elapsed time: ${stopwatch.elapsed.inMilliseconds}ms)');

  print('-'.padRight(40, '-'));

  stopwatch = Stopwatch()..start();
  await runnable.part2();
  stopwatch.stop();
  print('(part2 elapsed time: ${stopwatch.elapsed.inMilliseconds}ms)');
}
