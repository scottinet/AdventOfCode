import 'dart:io';

void main(List<String> args) async {
  final stopwatch = Stopwatch()..start();

  if (args.length != 1) {
    print('Usage: dart part1.dart <input_file>');
    exit(1);
  }

  String content = await File(args[0]).readAsString();
  int floor = 0;
  int basementEnteredAt = -1;

  for (int i = 0; i < content.length; i++) {
    if (content[i] == '(') {
      floor++;
    } else if (content[i] == ')') {
      floor--;
    }

    if (basementEnteredAt == -1 && floor == -1) {
      basementEnteredAt = i + 1;
    }
  }

  print('Floor: $floor');
  print('Basement entered at: $basementEnteredAt');

  stopwatch.stop();
  print('Elapsed time: ${stopwatch.elapsed.inMilliseconds}ms');
}
