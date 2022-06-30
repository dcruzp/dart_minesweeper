class BoardSquare {
  bool hasBomb;
  int bombsAround;
  bool discover;

  BoardSquare(
      {this.hasBomb = false, this.bombsAround = 0, this.discover = false});
}
