import 'dart:async';

import 'package:flutter_path_finder_algorithms/path_finders/base_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

class AStarPathFinder extends BasePathFinder {
  AStarPathFinder() : super('A* Path Finder');

  @override
  Stream<List<List<Node>>> call(
    List<List<Node>> graph,
    Node start,
    Node end, [
    Duration delay = const Duration(milliseconds: 10),
  ]) async* {
    final List<Node> queue = <Node>[start];

    while (queue.isNotEmpty) {
      final Node node = _getBest(queue);

      if (node == end) {
        return;
      }

      node.visited = true;

      final List<Node> neighbors = getNeighbors(graph, node);

      for (final Node neighbor in neighbors) {
        if (neighbor.visited) {
          continue;
        }

        neighbor
          ..g = node.g + 1
          ..h = _calculateHuristic(neighbor, end).toDouble()
          ..f = neighbor.g + neighbor.h
          ..visited = true
          ..previous = node;

        queue.add(neighbor);
      }

      await Future<void>.delayed(delay);
      yield graph;
    }
  }

  double _calculateHuristic(Node node, Node end) =>
      (node.position.dx - end.position.dx).abs() +
      (node.position.dy - end.position.dy).abs();

  Node _getBest(final List<Node> queue) {
    Node best = queue.first;

    for (final Node node in queue) {
      if (node.f < best.f) {
        best = node;
      }
    }

    queue.remove(best);

    return best;
  }
}
