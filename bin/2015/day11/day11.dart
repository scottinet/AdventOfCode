import 'dart:async';

import 'package:advent_of_code/runnable.dart';

class Y2015Day11 implements Runnable {
  String _currentPassword = "";
  String _nextPassword = "";
  final _forbiddenChars = "iol".codeUnits;
  final _a = "a".codeUnitAt(0);
  final _z = "z".codeUnitAt(0);

  @override
  FutureOr<void> init(Stream<String> input,
      {List<String> args = const []}) async {
    _currentPassword = await input.join();
  }

  @override
  FutureOr<void> part1() {
    List<int> pwd = List.from(_currentPassword.codeUnits);

    do {
      increasePassword(pwd);
    } while (!isPasswordValid(pwd));

    _nextPassword = String.fromCharCodes(pwd);
    print("Next password: $_nextPassword");
  }

  @override
  FutureOr<void> part2() {
    List<int> pwd = List.from(_nextPassword.codeUnits);

    do {
      increasePassword(pwd);
    } while (!isPasswordValid(pwd));

    print("Next (next) password: ${String.fromCharCodes(pwd)}");
  }

  void increasePassword(List<int> pwd) {
    final idx = pwd.lastIndexWhere((c) => c != _z);

    pwd[idx]++;

    for (int i = idx + 1; i < pwd.length; i++) {
      pwd[i] = _a;
    }
  }

  bool isPasswordValid(List<int> pwd) {
    bool hasStraight = false;
    List<int> dbls = [];

    for (int i = 0; i < pwd.length; i++) {
      if (_forbiddenChars.contains(pwd[i])) return false;

      if (!hasStraight && i < pwd.length - 2) {
        hasStraight =
            pwd[i] == pwd[i + 1] - 1 && pwd[i + 1] - 1 == pwd[i + 2] - 2;
      }

      if (dbls.length < 2 &&
          !dbls.contains(pwd[i]) &&
          i < pwd.length - 1 &&
          pwd[i] == pwd[i + 1]) {
        dbls.add(pwd[i]);
      }
    }

    return hasStraight && dbls.length >= 2;
  }
}
