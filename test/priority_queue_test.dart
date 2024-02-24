import 'package:aoc2015/prority_queue.dart';
import 'package:test/test.dart';

void main() {
  test('PriorityQueue removeFirst', () {
    final queue = PriorityQueue();

    queue.add(1);
    queue.add(2);
    queue.add(3);
    queue.add(4);
    queue.add(5);

    expect(queue.removeFirst(), 1);
    expect(queue.removeFirst(), 2);
    expect(queue.removeFirst(), 3);
    expect(queue.removeFirst(), 4);
    expect(queue.removeFirst(), 5);
  });

  test('PriorityQueue remove', () {
    final queue = PriorityQueue();

    queue.add(1);
    queue.add(2);
    queue.add(3);
    queue.add(4);
    queue.add(5);

    queue.remove(3);

    expect(queue.removeFirst(), 1);
    expect(queue.removeFirst(), 2);
    expect(queue.removeFirst(), 4);
    expect(queue.removeFirst(), 5);
  });

  test('PriorityQueue merge', () {
    final queue1 = PriorityQueue();
    final queue2 = PriorityQueue();

    queue1.add(1);
    queue1.add(2);
    queue1.add(3);
    queue1.add(4);
    queue1.add(5);

    queue2.add(6);
    queue2.add(7);
    queue2.add(8);
    queue2.add(9);
    queue2.add(10);

    queue1.merge(queue2);

    expect(queue1.removeFirst(), 1);
    expect(queue1.removeFirst(), 2);
    expect(queue1.removeFirst(), 3);
    expect(queue1.removeFirst(), 4);
    expect(queue1.removeFirst(), 5);
    expect(queue1.removeFirst(), 6);
    expect(queue1.removeFirst(), 7);
    expect(queue1.removeFirst(), 8);
    expect(queue1.removeFirst(), 9);
    expect(queue1.removeFirst(), 10);
  });

  test('PriorityQueue potential', () {
    final queue = PriorityQueue();

    queue.add(1);
    queue.add(2);
    queue.add(3);
    queue.add(4);
    queue.add(5);

    expect(queue.potential, 5);
  });

  test('PriorityQueue min', () {
    final queue = PriorityQueue();

    queue.add(1);
    queue.add(2);
    queue.add(3);
    queue.add(4);
    queue.add(5);

    expect(queue.min, 1);
  });

  test('PriorityQueue size', () {
    final queue = PriorityQueue();

    queue.add(1);
    queue.add(2);
    queue.add(3);
    queue.add(4);
    queue.add(5);

    expect(queue.size, 5);
  });
}
