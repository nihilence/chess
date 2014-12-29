class SteppingPiece < Piece


  def moves(pos, directions)
    legal_moves = []
    pos_x, pos_y = pos
    directions.each do |direction|
      dx, dy = direction
      next_pos = [pos_x + dx, pos_y + dy]
      legal_moves << next_pos if is_legal?(next_pos)
    end

    legal_moves
  end


  def is_legal?(pos)
    #   checks if there is a piece in the spot and whether it is the same
    # color. Also checks if it is off of the board.
    return false unless pos[0].between?(0, 7) && pos[1].between?(0, 7)
    return true if board[pos.first][pos.last].nil?
    return false if self.color == board[pos.first][pos.last].color

    true
  end


end
