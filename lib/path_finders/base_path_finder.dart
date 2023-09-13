import 'dart:async';

import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

abstract class BasePathFinder {
  BasePathFinder(this.name);

  final String name;

  final StreamController<List<List<Node>>> searchStreamController =
      StreamController<List<List<Node>>>();

  final StreamController<List<Node>> pathStreamController =
      StreamController<List<Node>>();

  Stream<List<List<Node>>> get searchStream => searchStreamController.stream;

  Stream<List<Node>> get pathStream => pathStreamController.stream;

  void run(List<List<Node>> graph, Node start, Node end, [Duration delay]);

  List<Node> getNeighbors(List<List<Node>> graph, Node node) {
    final List<Node> neighbors = <Node>[];

    final List<List<int>> directions = <List<int>>[
      <int>[0, -1],
      <int>[1, 0],
      <int>[0, 1],
      <int>[-1, 0],
    ];

    for (final List<int> direction in directions) {
      final int x = (node.position.dx + direction.first).floor();
      final int y = (node.position.dy + direction.last).floor();

      final bool isValid = x >= 0 &&
          x < graph.first.length &&
          y >= 0 &&
          y < graph.length &&
          !graph[y][x].isWall;

      if (isValid) {
        neighbors.add(graph[y][x]);
      }
    }

    return neighbors;
  }

  Future<void> getPath(Node end) async {
    final List<Node> path = <Node>[];

    Node node = end;

    while (node.previous != null) {
      path.add(node);
      node = node.previous!;
    }

    path.add(node);

    final List<Node> pathReversed = <Node>[];

    while (path.isNotEmpty) {
      pathReversed.add(path.removeLast());

      await Future<void>.delayed(const Duration(milliseconds: 32));
      pathStreamController.add(pathReversed);
    }
  }

  void dispose() {
    searchStreamController.close();
    pathStreamController.close();
  }
}
