# Flutter Path Finder

This Flutter package provides an implementation of path-finding algorithms including Breadth-First Search (BFS), Depth-First Search (DFS), and A\* Search. It also includes a visualization component to help you visualize the algorithms in action.

![Path Finder Demo](/path_finder.gif)

## Algorithms Implemented

1. [A\* Search](https://en.wikipedia.org/wiki/A*_search_algorithm)
   A\* is a widely used path-finding algorithm that combines the advantages of both Dijkstra's algorithm and Greedy Best-First Search. It is known for its efficiency and accuracy in finding the shortest path.

2. [Breadth-First Search](https://en.wikipedia.org/wiki/Breadth-first_search)
   BFS is a simple and effective algorithm for exploring all possible paths in a graph systematically. It guarantees finding the shortest path when all edges have the same weight.

3. [Depth-First Search](https://en.wikipedia.org/wiki/Depth-first_search)
   DFS is another graph traversal algorithm that explores as far as possible along each branch before backtracking. It is not guaranteed to find the shortest path, but it can be useful in certain scenarios.

## How to Use

1. Clone or download this repository to your Flutter project.
2. Import the necessary path-finder class in your Dart file.
3. Create a grid of nodes where you want to find the path.
4. Instantiate the path-finder of your choice (A\*, BFS, or DFS).
5. Run the path-finding algorithm by calling the `call` method with the graph, start node, and end node as parameters.

```dart
// Create a grid of nodes (List<List<Node>> graph) Instantiate the A* path-finder.
final BasePathFinder pathFinder = AStarPathFinder();

// Run the A* algorithm.
pathFinder(graph, startNode, endNode).listen((graph) {
  // Do something with the graph.
});

// Get shortest path.
pathFinder.getShortestPath(endNode).listen((data) {
  // Do something with the path.
});
```

You can customize the delay between steps of the algorithm by providing a `Duration` as an optional parameter.

### Visualization

The repository includes a Flutter app that visualizes the path-finding algorithms in action. It displays a grid with obstacles, the start and end points, and the path found by the selected algorithm. You can use this app as a reference for integrating the path-finding algorithms into your Flutter project.

## Node Class

The `Node` class represents a node on the grid. It contains information about its position, whether it has been visited, whether it is a wall (obstacle), and other properties required for path finding.

## PathFinderPainter Class

The `PathFinderPainter` class is responsible for rendering the grid, nodes, and path on the screen. It uses custom painting to visualize the algorithm's progress.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```

```
