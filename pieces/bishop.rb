class Bishop < SlidingPiece
  # returns an array of moves that the bishop can move into.


  def move_dirs
    moves(self.pos, Piece::DIAGONALS)
  end
end
