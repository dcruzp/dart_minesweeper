import 'boardsquare.dart';
import 'dart:io';
import 'dart:math';
import 'dart:collection';

class Board {
  late int rowCount, columnCount, amountBombs;
  late List<List<BoardSquare>> _board;
  static int discovered = 0;
  static List<int> _dirRow = [-1, -1, -1, 0, 1, 1, 1, 0];
  static List<int> _dirCol = [-1, 0, 1, 1, 1, 0, -1, -1];

  Board(int rowCount, int columnCount, int amountBombs) {
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    this.amountBombs = amountBombs;
    _board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardSquare();
      });
    });
    _putBombs();
    _bombsAround();
  }

  void print() {
    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        if (!_board[i][j].discover) {
          stdout.write("_ ");
        } else if (_board[i][j].hasBomb) {
          stdout.write("X ");
        } else {
          stdout.write("${_board[i][j].bombsAround} ");
        }
      }
      stdout.write('\n');
    }
  }

  _putBombs() {
    Random random = Random();
    int count = amountBombs;

    while (count > 0) {
      int row = random.nextInt(rowCount);
      int col = random.nextInt(columnCount);
      if (_board[row][col].hasBomb) continue;
      _board[row][col].hasBomb = true;
      count--;
    }
  }

  _bombsAround() {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        var count = 0;
        for (int r = 0; r < 8; r++) {
          int newrow = i + _dirRow[r];
          int newcol = j + _dirCol[r];
          if (newrow < 0 ||
              newcol < 0 ||
              newrow >= rowCount ||
              newcol >= columnCount) continue;
          if (_board[newrow][newcol].hasBomb) count += 1;
        }
        _board[i][j].bombsAround = count;
      }
    }
  }

  bool _isInRange(Point p) {
    return p.x >= 0 && p.x < rowCount && p.y >= 0 && p.y < columnCount;
  }

  int pressSquare(int row, int col) {
    if (!_isInRange(Point(row, col))) return -2;
    if (_board[row][col].hasBomb) {
      if (!_board[row][col].discover) _board[row][col].discover = true;
      return -1;
    }

    int _count = 0;
    List<List<bool>> _visited = List.generate(
        rowCount, (x) => List.generate(columnCount, (y) => false));
    Queue<Point<int>> _queue = new Queue<Point<int>>();

    if (!_board[row][col].discover) {
      _board[row][col].discover = true;
      _count++;
    }
    _visited[row][col] = true;
    _queue.add(Point(row, col));

    while (!_queue.isEmpty) {
      var current = _queue.removeFirst();

      for (var r = 0; r < 8; r += 2) {
        Point<int> newcell =
            Point<int>(current.x + _dirRow[r], current.y + _dirCol[r]);
        if (!_isInRange(newcell) ||
            _visited[newcell.x][newcell.y] ||
            _board[newcell.x][newcell.y].hasBomb) continue;
        _visited[newcell.x][newcell.y] = true;
        if (!_board[newcell.x][newcell.y].discover) {
          _board[newcell.x][newcell.y].discover = true;
          _count++;
        }
        _queue.add(newcell);
      }
    }
    discovered += _count;
    if (discovered + amountBombs == rowCount * columnCount) return -2;
    return _count;
  }
}
