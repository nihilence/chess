class King < SteppingPiece

  def move_dirs
    moves(self.pos, Piece::ORTHOGONALS) + moves(self.pos, Piece::DIAGONALS)
  end
end
