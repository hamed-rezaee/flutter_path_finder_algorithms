import 'package:flutter/material.dart';

class Node {
  Node(this.position);

  final Offset position;

  bool visited = false;
  bool isWall = false;

  Node? previous;

  double f = 0;
  double g = 0;
  double h = 0;
}
