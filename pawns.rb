class Pawn < Piece

  def moves
    moves = []
    moves += [forward_one].compact
    moves += [forward_two].compact unless moves.empty?
    moves += diagonal_moves
  end

  def direction
    self.color == :white ? -1 : 1
  end

  def forward_one
    new_pos = [pos[0] + direction, pos[1]]
    new_pos if board.on_board?(new_pos) && board[new_pos].nil?
  end

  def forward_two
    new_pos = [pos[0] + direction * 2, pos[1]]
    unless moved
      new_pos if board[new_pos].nil?
    end
  end

  def diagonal_moves
    moves = []
    [1, -1].each do |dcol|
      new_pos = [pos[0] + direction, pos[1] + dcol]
      next unless board.on_board?(new_pos)

      moves << new_pos if board[new_pos] && board[new_pos].color != color
    end

    moves
  end

  def to_s
    self.color == :white ? "\u2659" : "\u265F"
  end
end