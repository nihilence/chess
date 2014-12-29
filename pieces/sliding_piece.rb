class SlidingPiece < Piece

  # returns a list of moves that represent squares that extend from the position
  # to the edges of the board or until it reaches a piece.
  def moves(pos = self.pos, directions)
    legal_moves = []
    pos_x, pos_y = pos
    directions.each do |direction|
      x, y = direction

      edge_or_piece = false

      next_position = [pos_x + x, pos_y + y]

      until edge_or_piece
        next_x, next_y = next_position
        valid = is_legal?(next_position)
        legal_moves << next_position if valid
        if !valid
          edge_or_piece = true
        elsif valid && !board[next_position.first][next_position.last].nil?
          edge_or_piece = true
        end
        next_position = [next_position.first + x, next_position.last + y]
      end
    end

    legal_moves
  end


  # returns whether a piece can move into the square.
  def is_legal?(pos)
    #   checks if there is a piece in the spot and whether it is the same
    # color. Also checks if it is off of the board.
    return false unless pos[0].between?(0, 7) && pos[1].between?(0, 7)
    return true if board[pos.first][pos.last].nil?
    return false if self.color == board[pos.first][pos.last].color

    true
  end


end
