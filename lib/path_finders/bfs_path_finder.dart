import 'dart:async';

import 'package:flutter_path_finder_algorithms/path_finders/base_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

class BFSPathFinder extends BasePathFinder {
  BFSPathFinder() : super('BFS Path Finder');

  @override
  Stream<List<List<Node>>> call(
    List<List<Node>> graph,
    Node start,
    Node end, [
    Duration delay = const Duration(milliseconds: 10),
  ]) async* {
    final List<Node> queue = <Node>[start];

    while (queue.isNotEmpty) {
      final Node node = queue.removeAt(0);

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
          ..visited = true
          ..previous = node;

        queue.add(neighbor);
      }

      await Future<void>.delayed(delay);
      yield graph;
    }
  }
}
