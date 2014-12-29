class Rook < SlidingPiece

  def move_dirs
    moves(self.pos, Piece::ORTHOGONALS)
  end
end
