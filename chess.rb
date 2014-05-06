require 'colorize'
require 'yaml'
require_relative 'game'
require_relative 'pieces'
require_relative 'sliding_pieces'
require_relative 'stepping_pieces'
require_relative 'pawns'
require_relative 'board'

if __FILE__ == $PROGRAM_NAME
  unless ARGV.empty?
    game = YAML.load_file(ARGV.shift)
  else
    game = Game.new
  end

  game.run
end