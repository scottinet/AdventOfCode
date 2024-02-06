import "package:equatable/equatable.dart";

class Point extends Equatable {
  final double x;
  final double y;

  Point(this.x, this.y);

  @override
  List<Object> get props => [x, y];

  @override
  String toString() {
    return 'Point{x: $x, y: $y}';
  }
}
