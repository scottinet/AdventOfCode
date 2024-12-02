import 'dart:convert';
import 'dart:io';

import 'package:advent_of_code/runnable.dart';
import 'bin/2015/day01/day01.dart';
import 'bin/2015/day02/day02.dart';
import 'bin/2015/day03/day03.dart';
import 'bin/2015/day04/day04.dart';
import 'bin/2015/day05/day05.dart';
import 'bin/2015/day06/day06.dart';
import 'bin/2015/day07/day07.dart';
import 'bin/2015/day08/day08.dart';
import 'bin/2015/day09/day09.dart';
import 'bin/2015/day10/day10.dart';
import 'bin/2015/day11/day11.dart';
import 'bin/2015/day12/day12.dart';
import 'bin/2015/day13/day13.dart';
import 'bin/2015/day14/day14.dart';
import 'bin/2015/day15/day15.dart';
import 'bin/2015/day16/day16.dart';
import 'bin/2015/day17/day17.dart';
import 'bin/2015/day18/day18.dart';
import 'bin/2015/day19/day19.dart';

Map<String, Runnable> dayRunners = {
  'day01': Y2015Day01(),
  'day02': Y2015Day02(),
  'day03': Y2015Day03(),
  'day04': Y2015Day04(),
  'day05': Y2015Day05(),
  'day06': Y2015Day06(),
  'day07': Y2015Day07(),
  'day08': Y2015Day08(),
  'day09': Y2015Day09(),
  'day10': Y2015Day10(),
  'day11': Y2015Day11(),
  'day12': Y2015Day12(),
  'day13': Y2015Day13(),
  'day14': Y2015Day14(),
  'day15': Y2015Day15(),
  'day16': Y2015Day16(),
  'day17': Y2015Day17(),
  'day18': Y2015Day18(),
  'day19': Y2015Day19(),
};

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
