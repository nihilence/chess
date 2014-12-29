# General class that's the foundation for the other classes.
class Piece


  ORTHOGONALS = [[0,-1], [0,1], [1,0], [-1, 0]]
  DIAGONALS   = [[-1,-1], [-1,1], [1,-1], [1,1]]

  SYMBOLS = { "Pawn" => [ "\u2659", "\u265F"],
              "Bishop" => [ "\u2657", "\u265D"],
              "Knight" => [ "\u2658", "\u265E"],
              "King" => [ "\u2654", "\u265A"],
              "Queen" => ["\u2655", "\u265B"],
              "Rook" => ["\u2656", "\u265C"]}

  attr_accessor :pos, :board, :symbol
  attr_reader   :color, :symbol

  def initialize(pos, color, board)
    @pos, @color, @board = pos, color, board.grid
    @board_obj = board
    assign_symbol

  end

  def assign_symbol
    @symbol = SYMBOLS[self.class.to_s][0] if color == :white
    @symbol = SYMBOLS[self.class.to_s][1] if color == :black
  end

  def inspect
    [pos, color]
    # " #{symbol} "
  end

  def move_into_check?(end_pos)
    dup_board = @board_obj.dup
    dup_board.move!(pos,end_pos)

    dup_board.in_check?(self.color)
  end

  def valid_moves
    legal_moves = []

    self.move_dirs.each do |move|

      legal_moves << move unless move_into_check?(move)
    end

    legal_moves
  end

end
