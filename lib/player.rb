class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  # Gets the move from the player and converts the chess notation into board indices
  def get_move
    puts "#{color.capitalize}, enter your move (e.g., 'e2 e4'):"
    move = gets.chomp
    from, to = move.split
    [convert_to_index(from), convert_to_index(to)]
  end

  # Converts chess notation like 'e2' to array indices like [6, 4]
  def convert_to_index(chess_notation)
    column = chess_notation[0].ord - 'a'.ord # 'a' -> 0, 'b' -> 1, etc.
    row = 8 - chess_notation[1].to_i # '7' -> 1 (because '7' means row 1)
    [row, column]
  end
end
