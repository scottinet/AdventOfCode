import 'package:equatable/equatable.dart';

class Reindeer implements Equatable {
  final String name;
  final int restTime;
  final int velocity;
  final int flyTime;

  const Reindeer(
      {required this.name,
      required this.velocity,
      required this.restTime,
      required this.flyTime});

  @override
  List<Object?> get props => [name];

  @override
  bool? get stringify => false;
}
