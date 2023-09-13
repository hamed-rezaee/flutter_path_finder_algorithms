import 'dart:async';

import 'package:flutter_path_finder_algorithms/enums.dart';
import 'package:flutter_path_finder_algorithms/node.dart';

class PathFinder {
  final StreamController<List<List<Node>>> _searchStreamController =
      StreamController<List<List<Node>>>();

  final StreamController<List<Node>> _pathStreamController =
      StreamController<List<Node>>();

  Stream<List<List<Node>>> get searchStream => _searchStreamController.stream;

  Stream<List<Node>> get pathStream => _pathStreamController.stream;

  void execute(
    List<List<Node>> graph,
    Node start,
    Node end,
    Algorithm algorithm, [
    Duration delay = const Duration(milliseconds: 10),
  ]) {
    switch (algorithm) {
      case Algorithm.bfs:
        _bfs(graph, start, end, delay);
        break;
      case Algorithm.dfs:
        dfs(graph, start, end, delay);
        break;
      case Algorithm.aStar:
        _astar(graph, start, end, delay);
        break;
    }
  }

  Future<void> _bfs(
    List<List<Node>> graph,
    Node start,
    Node end,
    Duration delay,
  ) async {
    final List<Node> queue = <Node>[start];

    while (queue.isNotEmpty) {
      final Node node = queue.removeAt(0);

      if (node == end) {
        return;
      }

      node.visited = true;

      final List<Node> neighbors = _getNeighbors(graph, node);

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
      _searchStreamController.add(graph);
    }
  }

  Future<void> dfs(
    List<List<Node>> graph,
    Node start,
    Node end,
    Duration delay,
  ) async {
    final List<Node> stack = <Node>[start];

    while (stack.isNotEmpty) {
      final Node node = stack.removeLast();

      if (node == end) {
        return;
      }

      node.visited = true;

      final List<Node> neighbors = _getNeighbors(graph, node);

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
      _searchStreamController.add(graph);
    }
  }

  Future<void> _astar(
    List<List<Node>> graph,
    Node start,
    Node end,
    Duration delay,
  ) async {
    final List<Node> queue = <Node>[start];

    while (queue.isNotEmpty) {
      final Node node = _getBest(queue);

      if (node == end) {
        return;
      }

      node.visited = true;

      final List<Node> neighbors = _getNeighbors(graph, node);

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
      _searchStreamController.add(graph);
    }
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
      _pathStreamController.add(pathReversed);
    }
  }

  static Node _getBest(final List<Node> queue) {
    Node best = queue.first;

    for (final Node node in queue) {
      if (node.f < best.f) {
        best = node;
      }
    }

    queue.remove(best);

    return best;
  }

  static double _calculateHuristic(Node node, Node end) =>
      (node.position.dx - end.position.dx).abs() +
      (node.position.dy - end.position.dy).abs();

  static List<Node> _getNeighbors(
    List<List<Node>> graph,
    Node node,
  ) {
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

  void dispose() {
    _searchStreamController.close();
    _pathStreamController.close();
  }
}
