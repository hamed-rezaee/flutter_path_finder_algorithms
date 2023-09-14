import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_path_finder_algorithms/path_finder_painter.dart';
import 'package:flutter_path_finder_algorithms/path_finders/astar_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/base_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/bfs_path_finder.dart';
import 'package:flutter_path_finder_algorithms/path_finders/node.dart';

const int size = 40;
const int walls = 400;

const Offset startPosition = Offset.zero;
const Offset endPosition = Offset(size - 1, size - 1);

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<Node>> nodes =
        _generateNodes(size, walls, startPosition, endPosition);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            _drawMap(Node.cloneList(nodes), BFSPathFinder()),
            _drawMap(Node.cloneList(nodes), AStarPathFinder()),
          ],
        ),
      ),
    );
  }

  Widget _drawMap(List<List<Node>> nodes, BasePathFinder pathFinder) {
    final int startX = startPosition.dx.floor();
    final int startY = startPosition.dy.floor();

    final int endX = endPosition.dx.floor();
    final int endY = endPosition.dy.floor();

    final Node start = nodes[startX][startY];
    final Node end = nodes[endX][endY];

    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          '${pathFinder.name}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<List<Node>>>(
          stream: pathFinder(nodes, start, end),
          initialData: nodes,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<List<Node>>> finderSnapshot,
          ) =>
              StreamBuilder<List<Node>>(
            stream: pathFinder.getPath(end),
            initialData: const <Node>[],
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Node>> pathSnapshot,
            ) =>
                CustomPaint(
              size: const Size(400, 400),
              painter: PathFinderPainter(
                finderSnapshot.data!,
                pathSnapshot.data!,
                start,
                end,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<List<Node>> _generateNodes(
    int size,
    int walls,
    Offset start,
    Offset end,
  ) {
    final List<List<Node>> nodes = <List<Node>>[];

    for (int i = 0; i < size; i++) {
      final List<Node> row = <Node>[];

      for (int j = 0; j < size; j++) {
        row.add(Node(Offset(j.toDouble(), i.toDouble())));
      }

      nodes.add(row);
    }

    for (int i = 0; i < walls; i++) {
      final int row = Random().nextInt(size);
      final int column = Random().nextInt(size);

      final int startX = start.dx.floor();
      final int startY = start.dy.floor();

      final int endX = end.dx.floor();
      final int endY = end.dy.floor();

      if (nodes[row][column] == nodes[startY][startX] ||
          nodes[row][column] == nodes[endY][endX]) {
        i--;

        continue;
      }

      nodes[row][column].isWall = true;
    }

    return nodes;
  }
}
