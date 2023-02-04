// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:math' as math;

class Node {
  bool isAlive;
  Set<Node> neighbours;

  int get numAlive => neighbours.where((v) => v.isAlive).length;

  bool get nextState {
    final int n = numAlive;
    return (isAlive && n == 2) || n == 3;
  }

  Node({this.isAlive = false, this.neighbours = const {}});
}

class Conway {
  static const gridSize = 100;
  static const gridSizeSquared = gridSize * gridSize;
  final List<int> _mooreRange = [-1, 0, 1];

  List<Node> nodes = [];

  Conway() {
    for (int i = 0; i < gridSizeSquared; i++)
      nodes.add(Node(isAlive: math.Random().nextBool()));

    for (int i = 0; i < gridSizeSquared; i++)
      nodes[i].neighbours = {
        ..._mooreNeighbours(i).where((n) => n != nodes[i])
      };
  }

  Iterable<Node> _mooreNeighbours(int i) sync* {
    final c = indexToCoords(i);
    for (int ox in _mooreRange)
      for (int oy in _mooreRange)
        yield nodes[l(c.first + ox) + l(c.last + oy) * gridSize];
  }

  List<int> indexToCoords(int i) => [i % gridSize, i ~/ gridSize];

  int l(int v) => v.clamp(0, gridSize - 1);

  void next() {
    final nextAlive = nodes.map((n) => n.nextState).toList();
    for (int i = 0; i < gridSizeSquared; i++)
      nodes[i].isAlive = nextAlive[i];
  }
}
