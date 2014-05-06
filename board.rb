# encoding: utf-8

class MoveError < StandardError
end

class Board

  BACK_ROW = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_accessor :grid

  def initialize(setup = true)
    @grid = Array.new(8) { Array.new(8) }
    setup_board if setup
  end

  def render
    display = ""
    display << render_first_row
    display << render_grid
    display << render_last_row
  end

  def [](pos)
    row, col = pos
    self.grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    self.grid[row][col] = piece
  end

  def on_board?(pos)
    row, col = pos
    [row, col].all? do |coord|
      coord.between?(0, self.grid.length - 1)
    end
  end

  def in_check?(color)
    king = find_king(color)

    all_pieces.each do |piece|
      next if piece.is_a?(King)
      return true if piece.color != color && piece.moves.include?(king.pos)
    end

    false
  end

  def move(start, end_pos)
    raise MoveError.new "No piece there!" if self[start].nil?

    unless self[start].moves.include?(end_pos)
      raise MoveError.new "Piece cannot move there!"
    end

    unless self[start].valid_moves.include?(end_pos)
      raise MoveError.new "Can't put yourself in check!"
    end

    if kamikaze_king?(start, end_pos)
      raise MoveError.new "King, you have so much to live for!"
    end

    self.move!(start, end_pos)
    castle_rook(start, end_pos) if castle?(start, end_pos)
  end

  def move!(start, end_pos)
    self[end_pos] = self[start]
    self[start] = nil
    self[end_pos].pos = end_pos
    self[end_pos].moved = true
  end

  def castle_rook(start, end_pos)
    if (end_pos[1] - start[1]) == 2
      rook_start = [start[0], 7]
      rook_end = [start[0], 5]
    else
      rook_start = [start[0], 0]
      rook_end = [start[0], 3]
    end

    move!(rook_start, rook_end)
  end

  def castle?(start, end_pos)
    self[end_pos].class == King && (end_pos[1] - start[1]).abs == 2
  end

  def deep_dup
    dupped_board = Board.new(false)

    all_pieces.each do |piece|
      dupped_piece = piece.dup(dupped_board)
    end

    dupped_board
  end

  def no_legal_moves?(color)
    all_pieces.each do |piece|
      return false if piece.color == color && !piece.valid_moves.empty?
    end

    true
  end

  private
  def setup_board
    BACK_ROW.each_with_index do |piece_class, idx|
      self.grid[0][idx] = piece_class.new(self, [0, idx], :black)
      self.grid[7][idx] = piece_class.new(self, [7, idx], :white)
    end

    self.grid.length.times do |idx|
      self.grid[1][idx] = Pawn.new(self, [1, idx], :black)
      self.grid[6][idx] = Pawn.new(self, [6, idx], :white)
    end
  end

  def render_first_row
    " " * 10 + "\n"
  end

  def render_grid
    display = ""
    self.grid.size.times do |row|
      display << "#{(8-row)}"
      self.grid.size.times do |col|
        bkgrnd = (row + col).even? ? :white : :green
        piece = self.grid[row][col]
        char = (piece ? piece.to_s : " ")

        display << (" " + char + " ").colorize(:background => bkgrnd)
      end

      display << " " + "\n"
    end

    display
  end

  def render_last_row
    display = " "
    0.upto(7) do |idx|
      display << " " + ("a".ord + idx).chr + " "
    end

    display << " " + "\n\n"
    display
  end

  def all_pieces
    grid.flatten.compact
  end

  def find_king(color)
    all_pieces.find { |piece| piece.class == King && piece.color == color }
  end

  def kamikaze_king?(start, end_pos)
    return false unless self[start].is_a?(King)

    other_color = (self[start].color == :white ? :black : :white)
    other_king_pos = find_king(other_color).pos

    row_diff = (end_pos[0] - other_king_pos[0]).abs
    col_diff = (end_pos[1] - other_king_pos[1]).abs
    return true if [0,1].include?(row_diff) && [0,1].include?(col_diff)

    false
  end
end