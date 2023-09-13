import 'dart:async';

import 'package:flutter_path_finder_algorithms/path_finders/base_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

class DFSPathFinder extends BasePathFinder {
  DFSPathFinder() : super('DFS Path Finder');

  @override
  Future<void> run(
    List<List<Node>> graph,
    Node start,
    Node end, [
    Duration delay = const Duration(milliseconds: 10),
  ]) async {
    final List<Node> stack = <Node>[start];

    while (stack.isNotEmpty) {
      final Node node = stack.removeLast();

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

        stack.add(neighbor);
      }

      await Future<void>.delayed(delay);
      searchStreamController.add(graph);
    }
  }
}
