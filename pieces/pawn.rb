class Pawn < SteppingPiece
  B_PAWN_MOVES = [[1, 0], [1, 1], [1, -1],[2,0]]
  W_PAWN_MOVES = [[-1, 0], [-1, 1], [-1, -1],[-2,0]]

  attr_reader :start_pos

  def initialize(pos, color, board)
    super
    @start_pos = pos
  end

  def moves(pos, directions)
    legal_moves = []


    directions = directions[0..2] unless self.pos == @start_pos
    directions.each do |direction|
      x, y = direction

      next_position = [pos.first + x, pos.last + y]
      next_x, next_y = next_position
      if is_legal?(next_position)
        if Piece::DIAGONALS.include?(direction)
          legal_moves << next_position unless board[next_x][next_y].nil?
        else
          legal_moves << next_position
        end
      end
    end

    legal_moves
  end

  def move_dirs
    if self.color == :black
      moves(pos, B_PAWN_MOVES)
    else
      moves(pos, W_PAWN_MOVES)
    end
  end

  def is_legal?(pos)
    pos_x, pos_y = pos
    one_row_up = self.pos.first + 1 if self.color == :black
    two_rows_up = self.pos.first + 2 if self.color == :black
    one_row_up = self.pos.first - 1 if self.color == :white
    two_rows_up = self.pos.first - 2 if self.color == :white

    #   checks if there is a piece in the spot and whether it is the same
    # color. Also checks if it is off of the board.
    return false unless pos[0].between?(0, 7) && pos[1].between?(0, 7)

    if pos_x == one_row_up && pos_y == self.pos.last
      return false unless board[one_row_up][pos_y].nil?
    elsif pos_x == two_rows_up
      return false unless board[one_row_up][pos_y].nil? && board[two_rows_up][pos_y].nil?
    end


    return true if board[pos.first][pos.last].nil?
    return false if self.color == board[pos.first][pos.last].color

    true
  end
end
