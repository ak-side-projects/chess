class Game

  attr_reader :player1, :player2, :current_player
  attr_accessor :board # UNDO after debugging

  def initialize
    @board = Board.new
    @player1 = HumanPlayer.new(:white, self)
    @player2 = HumanPlayer.new(:black, self)
    @current_player = @player1
  end

  def run
    until self.board.no_legal_moves?(current_player.color)
      start_turn
      execute_turn
    end

    end_game
  end

  private
  def start_turn
    puts board.render
    puts "It's #{current_player.color.to_s}'s turn."
    if board.in_check?(current_player.color)
      puts "#{current_player.color.capitalize}, you're in check!"
    end
  end

  def execute_turn
    begin
      start, end_pos = current_player.play_turn
      check_start_piece(start)
      self.board.move(start, end_pos)
    rescue MoveError
      puts "Please enter a valid move."
      retry
    end

    switch_player
  end

  def check_start_piece(start)
    raise MoveError if self.board[start].nil?
    raise MoveError if self.board[start].color != @current_player.color
  end

  def switch_player
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

  def end_game
    puts board.render

    if self.board.in_check?(current_player.color)
      switch_player
      puts "Checkmate! #{current_player.color.to_s.capitalize} won!"
    else
      puts "Stalemate!  Nice going..."
    end
  end
end

class HumanPlayer
  attr_reader :color, :game

  def initialize(color, game)
    @color = color
    @game = game
  end

  def play_turn
    begin
      puts "Where do you want to move from?"
      start = get_square

      puts "Where do you want to move to?"
      end_pos = get_square

      raise StandardError if end_pos == start
    rescue
      puts "Those are the same square!  Please enter a valid move."
      retry
    end

    [start, end_pos]
  end

  private
  def get_square
    begin
      input = gets.chomp
      save_game if input == "save"

      square = parse_input(input)
      unless square.all? { |el| el.between?(0,7)} || square.length != 2
        raise "That's not a square."
      end
    rescue
      puts "Please enter a valid square."
      retry
    end

    square
  end

  def parse_input(square)
    pos = square.split("")
    col = pos.first.ord - "a".ord
    row = 8 - pos.last.to_i

    [row, col]
  end

  def save_game
    puts "What do you call the file?"
    filename = gets.chomp

    File.write(filename, self.game.to_yaml)
    exit
  end
end