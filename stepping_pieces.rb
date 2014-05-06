class SteppingPiece < Piece

  def moves
    x, y = pos
    moves = []

    move_dirs.each do |(dx, dy)|
      new_pos = [x + dx, y + dy]

      if board.on_board?(new_pos)
        if !board[new_pos]
          moves << new_pos
        else
          moves << new_pos if board[new_pos].color != color
        end
      end
    end

    moves
  end
end

class Knight < SteppingPiece
  KNIGHT_DELTAS = [
    [1, 2],
    [-1, 2],
    [-1, -2],
    [1, -2],
    [2, -1],
    [2, 1],
    [-2, -1],
    [-2, 1]
  ]

  def move_dirs
    KNIGHT_DELTAS
  end

  def to_s
    self.color == :white ? "\u2658" : "\u265E"
  end

end

class King < SteppingPiece
  KING_DELTAS = [
    [1, 0],
    [0, 1],
    [0, -1],
    [1, 1],
    [-1, 0],
    [-1, -1],
    [-1, 1],
    [1, -1]
  ]

  def move_dirs
    KING_DELTAS + castling_deltas
  end

  def castling_deltas
    castling_deltas = []

    castling_deltas << [0, 2] if castle_right?
    castling_deltas << [0, -2] if castle_left?
    castling_deltas
  end

  def castle_right?
    return false if self.moved

    corner_piece = self.board[[pos[0], 7]]
    return false unless corner_piece.is_a?(Rook)
    return false if corner_piece.moved

    return false if self.board[[pos[0], 6]]
    return false if self.board[[pos[0], 5]]

    return false if self.board.in_check?(self.color)
    return false if move_into_check?([pos[0], 5])

    true
  end

  def castle_left?
    return false if self.moved

    corner_piece = self.board[[pos[0], 0]]
    return false unless corner_piece.is_a?(Rook)
    return false if corner_piece.moved

    return false if self.board[[pos[0], 3]]
    return false if self.board[[pos[0], 2]]
    return false if self.board[[pos[0], 1]]

    return false if self.board.in_check?(self.color)
    return false if move_into_check?([pos[0], 3])

    true
  end

  def to_s
    self.color == :white ? "\u2654" : "\u265A"
  end
end