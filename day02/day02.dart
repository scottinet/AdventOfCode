import 'dart:convert';
import 'dart:io';
import 'dart:math';

class InputData {
  final int length;
  final int width;
  final int height;

  InputData(this.length, this.width, this.height);
}

Future<List<InputData>> parse(String filename) async {
  Stream<String> lines = File(filename)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter());

  List<InputData> parsed = [];

  try {
    await for (String line in lines) {
      List<int> dimensions = line.split('x').map(int.parse).toList();
      parsed.add(InputData(dimensions[0], dimensions[1], dimensions[2]));
    }
  } catch (e) {
    print(e);
    return [];
  }

  return parsed;
}

void part1(List<InputData> data) {
  int result = 0;

  for (InputData d in data) {
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

void main(List<String> args) async {
  final stopwatch = Stopwatch()..start();

  if (args.length != 1) {
    print('Usage: dart part1.dart <input_file>');
    exit(1);
  }

  print(Directory.current.path);
  List<InputData> inputData = await parse(args[0]);
  part1(inputData);

  stopwatch.stop();
  print('Elapsed time: ${stopwatch.elapsed.inMilliseconds}ms');
}
