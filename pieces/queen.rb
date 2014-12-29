class Queen < SlidingPiece

  def move_dirs
    moves(self.pos, Piece::ORTHOGONALS) + moves(self.pos, Piece::DIAGONALS)
  end
end
