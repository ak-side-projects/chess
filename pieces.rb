class Piece

  attr_accessor :board, :pos, :color, :moved

  def initialize(board, pos, color)
    @board, @pos, @color = board, pos, color
    @moved = false
    @board[pos] = self
  end

  def move_into_check?(new_pos)
    dupped_board = board.deep_dup
    dupped_board.move!(self.pos, new_pos)
    dupped_board.in_check?(self.color)
  end

  def valid_moves
    self.moves.reject { |new_pos| move_into_check?(new_pos) }
  end

  def dup(board)
    self.class.new(board, self.pos, self.color)
  end

  def moves
    raise NotImplementedError
  end

  def render
    if self.color == :white
      char = WHITE_PIECES[self.class.to_s.to_sym]
    else
      char = BLACK_PIECES[self.class.to_s.to_sym]
    end

    char
  end
end