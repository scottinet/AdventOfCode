import 'package:aoc2015/prority_queue.dart';
import 'package:test/test.dart';

void main() {
  test('PriorityQueue removeFirst', () {
    final queue = PriorityQueue<String>();

    queue.add('foo', 1);
    queue.add('bar', 2);
    queue.add('baz', 3);
    queue.add('qux', 4);
    queue.add('fds', 5);

    expect(queue.removeFirst(), ('foo', 1));
    expect(queue.removeFirst(), ('bar', 2));
    expect(queue.removeFirst(), ('baz', 3));
    expect(queue.removeFirst(), ('qux', 4));
    expect(queue.removeFirst(), ('fds', 5));
  });

  test('PriorityQueue remove', () {
    final queue = PriorityQueue<String>();

    queue.add('foo', 1);
    queue.add('bar', 2);
    queue.add('baz', 3);
    queue.add('qux', 4);
    queue.add('fds', 5);

    queue.remove('baz');

    expect(queue.removeFirst(), ('foo', 1));
    expect(queue.removeFirst(), ('bar', 2));
    expect(queue.removeFirst(), ('qux', 4));
    expect(queue.removeFirst(), ('fds', 5));
  });

  test('PriorityQueue merge', () {
    final queue1 = PriorityQueue<int>();
    final queue2 = PriorityQueue<int>();

    queue1.add(1, 1);
    queue1.add(2, 2);
    queue1.add(3, 3);
    queue1.add(4, 4);
    queue1.add(5, 5);

    queue2.add(6, 6);
    queue2.add(7, 7);
    queue2.add(8, 8);
    queue2.add(9, 9);
    queue2.add(10, 10);

    queue1.merge(queue2);

    expect(queue1.removeFirst(), (1, 1));
    expect(queue1.removeFirst(), (2, 2));
    expect(queue1.removeFirst(), (3, 3));
    expect(queue1.removeFirst(), (4, 4));
    expect(queue1.removeFirst(), (5, 5));
    expect(queue1.removeFirst(), (6, 6));
    expect(queue1.removeFirst(), (7, 7));
    expect(queue1.removeFirst(), (8, 8));
    expect(queue1.removeFirst(), (9, 9));
    expect(queue1.removeFirst(), (10, 10));
  });

  test('PriorityQueue potential', () {
    final queue = PriorityQueue<String>();

    queue.add('foo', 1);
    queue.add('bar', 2);
    queue.add('baz', 3);
    queue.add('qux', 4);
    queue.add('fds', 5);

    expect(queue.potential, 5);
  });

  test('PriorityQueue min', () {
    final queue = PriorityQueue<String>();

    queue.add('foo', 1);
    queue.add('bar', 2);
    queue.add('baz', 3);
    queue.add('qux', 4);
    queue.add('fds', 5);

    expect(queue.min, 1);
  });

  test('PriorityQueue size', () {
    final queue = PriorityQueue<String>();

    queue.add('foo', 1);
    queue.add('bar', 2);
    queue.add('baz', 3);
    queue.add('qux', 4);
    queue.add('fds', 5);

    expect(queue.size, 5);
  });
}
