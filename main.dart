import 'dart:io';
import 'boardgame.dart';

void printBoardInConsole(Board board) {
  stdout.write("##################\n");
  board.print();
  stdout.write("##################\n");
}

void main() {
  Board board = new Board(10, 10, 30);

  int pressResult = 0;
  while (pressResult >= 0) {
    print("\x1B[2J\x1B[0;0H");
    printBoardInConsole(board);
    stdout.write("press row : ");
    var row = int.parse(stdin.readLineSync() ?? "");
    stdout.write("press column : ");
    var col = int.parse(stdin.readLineSync() ?? "");
    pressResult = board.pressSquare(row, col);
    if (pressResult == -1) {
      stdout.write("You press a bomb \n");
      printBoardInConsole(board);
      break;
    } else if (pressResult == -2) {
      stdout.write("you win the game");
    } else {
      stdout.write(
          "You have pressed over cell ($row,$col)  and have discovered $pressResult new cells\n");
    }
    stdin.readLineSync();
  }
}
