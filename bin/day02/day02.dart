import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../models/runnable.model.dart';

class InputData {
  final int length;
  final int width;
  final int height;

  InputData(this.length, this.width, this.height);
}

class Day02 extends Runnable {
  final List<InputData> _data;

  Day02() : _data = [];

  @override
  Future<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    Stream<String> lines = input.transform(LineSplitter());

    await for (String line in lines) {
      List<int> dimensions = line.split('x').map(int.parse).toList();
      _data.add(InputData(dimensions[0], dimensions[1], dimensions[2]));
    }
  }

  @override
  void part1() {
    int result = 0;

    for (var d in _data) {
      var faceAreas = [
        d.length * d.width,
        d.width * d.height,
        d.height * d.length
      ];
      var smallestFaceArea = faceAreas.reduce(min);
      result +=
          2 * faceAreas.reduce((agg, area) => agg + area) + smallestFaceArea;
    }

    print('Part 1: $result');
  }

  @override
  FutureOr<void> part2() {
    int result = 0;

    for (var d in _data) {
      var dims = [d.length, d.width, d.height]..sort(((a, b) => a - b));
      result += 2 * dims[0] + 2 * dims[1] + d.length * d.width * d.height;
    }

    print('Part 2: $result');
  }
}
