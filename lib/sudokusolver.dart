class SudokuProgram
{
  SudokuProgram({this.board})
  {
    _copyArray(board, copy_board);
  }

  var board = List.generate(9, (_) => List(9), growable: false);
  var copy_board = List.generate(9, (_) => List(9), growable: false);

  void reset()
  {
    _copyArray(copy_board, board);
  }
  bool _isinRow(int row,int col,int val)
  {
    bool status = false;
    int count=0;
    for(int i=0;i<9;i++)
    {
      if(board[row][i]==val)
        count++;
      if(count>1)
      {
        status=true;
        break;
      }
    }
    return status;
  }

  bool _isinCol(int row,int col,int val)
  {
    bool status = false;
    int count = 0;
    for (int i = 0; i < 9; i++)
    {
      if (board[i][col] == val)
        count++;
      if (count > 1){
        status=true;
        break;
      }
    }
    return status;
  }

  bool _isinGrid(int row,int col,int val)
  {
    bool status = false;
    int count=0;
    int gridx = ((col~/ 3).toInt() * 3);
    int gridy = ((row~/ 3).toInt() * 3);
    for(int i=0;i<9;i++)
    {
      if ((board[(gridy + (i~/3).toInt()).toInt()][(gridx + i % 3).toInt()]) == val)
        count++;
      if(count>1)
      {
        status=true;
        break;
      }
    }
    return status;
  }

  bool isValid()
  {
    bool status = true;
    for(int row=0;row<9;row++)
    {
      for(int col=0;col<9;col++)
      {
        if(board[row][col]==0){}
        else{
          if(_isinRow(row, col, board[row][col])){ status = false; break;}
          if(_isinCol(row, col, board[row][col])){ status = false; break;}
          if(_isinGrid(row, col, board[row][col])){ status = false; break;}
        }
      }
    }
    return status;
  }


  void print_board()
  {
    int j;
    print('----------------------------');
    for(j=0;j<9;j++)
    {
      print('${board[j]}');
    }
    print('----------------------------');

  }

  bool _canPlace9x9(List<List<dynamic>> board, int row, int col,int n)
  {
    if (board[row][col] != 0) return false;
    bool status = true;
    int gridx = ((col~/ 3).toInt() * 3);
    int gridy = ((row~/ 3).toInt() * 3);
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == n) { status = false; break; }
      if (board[i][col] == n) { status = false; break; }
      if ((board[(gridy + (i~/3).toInt()).toInt()][(gridx + i % 3).toInt()]) == n) { status = false; break; }
    }
    return status;
  }

  int _nextRow(List<List<dynamic>> board, int row, int col,int rowNext,int colNext)
  {
    int indexNext = 9 * 9 + 1;
    for (int i = row * 9 + col + 1; i < 9 * 9; i++) {
      if (board[(i~/9).toInt()][i % 9] == 0) {
        indexNext = i;
        break;
      }
    }
    return rowNext = (indexNext~/9).toInt();
  }

  int _nextCol(List<List<dynamic>> board, int row, int col,int rowNext,int colNext)
  {
    int indexNext = 9 * 9 + 1;
    for (int i = row * 9 + col + 1; i < 9 * 9; i++) {
      if (board[(i~/9)][i % 9] == 0) {

        indexNext = i;
        break;
      }
    }
    colNext  = indexNext%9;
    return colNext;
  }

  void _copyArray(List<List<dynamic>> board,List<List<dynamic>> copy_board) {
    for (int y = 0; y < 9; y++)
      for (int x = 0; x < 9; x++)
        copy_board[y][x] = board[y][x];
  }

  List<int> _findPlaceables(List<List<dynamic>> board, int row, int col)
  {
    List<int> placebles= List<int>();
    for (int n = 1; n <= 9; n++) {
      if (_canPlace9x9(board,row,col,n)) {
        placebles.add(n);
      }
    }
    return placebles;
  }

  bool solveSudoku9x9(List<List<dynamic>> board,int row, int col)
  {
    var copy_board = List.generate(9, (_) => List(9), growable: false);
    if (row > 8) {
      _copyArray(board, this.board);
      return true;}
    if (board[row][col] != 0) {
      int rowNext = row;
      int colNext = col;
      rowNext=_nextRow(board, row, col, rowNext, colNext);
      colNext=_nextCol(board, row, col, rowNext, colNext);
      return solveSudoku9x9(board, rowNext, colNext);
    }
    List<int> placebles = _findPlaceables(board, row, col);
    if ((placebles.length == 0)) {return false;}

    bool status = false;
    for (int i = 0; i < placebles.length; i++) {
      int n = placebles[i];
      _copyArray(board,copy_board);
      copy_board[row][col] = n;
      int rowNext = row;
      int colNext = col;
      rowNext=_nextRow(copy_board, row, col, rowNext, colNext);
      colNext=_nextCol(copy_board, row, col, rowNext, colNext);

      if (solveSudoku9x9(copy_board, rowNext, colNext)) {
        status = true;
        break;
      }
    }
    return status;
  }
}

void main()
{

  List<List<int>> board = [
    [5,3,0,0,7,0,0,0,0],
    [6,0,0,1,9,5,0,0,0],
    [0,9,8,0,0,0,0,6,0],
    [8,0,0,0,6,0,0,0,3],
    [4,0,0,8,0,3,0,0,1],
    [7,0,0,0,2,0,0,0,6],
    [0,6,0,0,0,0,2,8,0],
    [0,0,0,4,1,9,0,0,5],
    [0,0,0,0,8,0,0,7,9]
  ];


  final quiz = SudokuProgram(board: board);
  if(quiz.isValid()==true){
    print('It is a valid sudoku');
    quiz.print_board();
    quiz.solveSudoku9x9(board, 0, 0);
    quiz.print_board();
    quiz.reset();
    quiz.print_board();
  }
  else{
    print('It is not a valid sudoku');
  }

}