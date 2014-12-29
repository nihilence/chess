class Knight < SteppingPiece

  KNIGHT_MOVES = [[ 1, 2], [ 1, -2],
                  [-1, 2], [-1, -2],
                  [ 2, 1], [ 2, -1],
                  [-2, 1], [-2, -1]]


  def move_dirs
    moves(self.pos, KNIGHT_MOVES)
  end

end
