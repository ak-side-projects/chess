class SlidingPiece < Piece

  ROOK_DELTAS = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0]
  ]

  BISHOP_DELTAS = [
    [1, 1],
    [-1, 1],
    [1, -1],
    [-1, -1]
  ]

  def moves
    x, y = pos
    moves = []

    move_dirs.each do |(dx, dy)|
      new_pos = [x + dx, y + dy]

      until !board.on_board?(new_pos)
        if board[new_pos]
          moves << new_pos if board[new_pos].color != color
          break
        end

        moves << new_pos

        new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      end
    end

    moves
  end
end

class Rook < SlidingPiece

  def move_dirs
    ROOK_DELTAS
  end

  def to_s
    self.color == :white ? "\u2656" : "\u265C"
  end
end

class Bishop < SlidingPiece

  def move_dirs
    BISHOP_DELTAS
  end

  def to_s
    self.color == :white ? "\u2657" : "\u265D"
  end
end

class Queen < SlidingPiece

  def move_dirs
    ROOK_DELTAS + BISHOP_DELTAS
  end

  def to_s
    self.color == :white ? "\u2655" : "\u265B"
  end
end