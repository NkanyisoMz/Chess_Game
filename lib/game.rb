require_relative 'board'
require_relative 'player'
require 'yaml'

class Game
  attr_accessor :board, :current_player, :players

  def initialize
    @board = Board.new
    @players = { white: Player.new('white'), black: Player.new('black') }
    @current_player = @players[:white]
  end

  def play
    loop do
      display_board
      begin
        move = current_player.get_move
        handle_move(move)
      rescue StandardError => e
        puts "Error: #{e.message}. Try again."
        next
      end
      break if board.checkmate?(current_player.color)
      switch_turn
    end
    puts "#{current_player.color.capitalize} wins! Checkmate!"
  end

  def display_board
    puts "\n"
    board.grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        if piece.nil?
          print " . "
        else
          print " #{piece.symbol} "
        end
      end
      puts " #{8 - i}"
    end
    puts " a  b  c  d  e  f  g  h "
    puts "\n"
  end

  def handle_move(move)
    start_pos, end_pos = move
    raise "Invalid input format" unless start_pos && end_pos
    board.move_piece(start_pos, end_pos, current_player.color)
  end

  def switch_turn
    @current_player = (@current_player == @players[:white]) ? @players[:black] : @players[:white]
  end

  def save_game
    File.open('saved_game.yaml', 'w') { |file| file.puts YAML.dump(self) }
    puts "Game saved!"
  end

  def self.load_game
    saved_data = File.read('saved_game.yaml')
    YAML.load(saved_data)
  end
end