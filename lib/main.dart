import 'dart:async';
import 'package:conway/conway.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const GameOfLife());
}

class GameOfLife extends StatelessWidget {
  const GameOfLife({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameOfLiveCanvas(title: 'Game of Life'),
    );
  }
}

class GameOfLiveCanvas extends StatefulWidget {
  const GameOfLiveCanvas({super.key, required this.title});
  final String title;

  @override
  State<GameOfLiveCanvas> createState() => _GameOfLiveCanvasState();
}

class _GameOfLiveCanvasState extends State<GameOfLiveCanvas> {
  Conway _conway = Conway();
  final _nodes = StreamController<List<Node>>();

  _GameOfLiveCanvasState() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _conway.next();
      _nodes.add(_conway.nodes);
    });
  }

  void _restart() => setState(() {
        _conway = Conway();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        initialData: const [],
        stream: _nodes.stream,
        builder: (context, value) => GridView.count(
            crossAxisCount: Conway.gridSize,
            children: value.data!
                .map((n) =>
                    Container(color: n.isAlive ? Colors.white : Colors.grey))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'Restart',
        child: const Icon(Icons.repeat),
      ),
    );
  }
}
