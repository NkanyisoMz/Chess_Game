class Piece
  attr_reader :color
  attr_accessor :position

  def initialize(color, position)
    @color = color # 'white' or 'black'
    @position = position # [row, col] as [Integer, Integer]
  end

  # This method will be overridden in specific piece classes to return the symbol for each piece
  def symbol
    raise NotImplementedError, "This method should be overridden in a subclass"
  end

  # This method will be overridden in specific piece classes to define valid moves
  def valid_moves(board)
    raise NotImplementedError, "This method should be overridden in a subclass"
  end

  # Helper to check if a position is within the bounds of the board
  def within_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  # Helper to check if a move is valid on the board (either to an empty square or capturing an enemy piece)
  def valid_move?(board, pos)
    within_bounds?(pos) && (board.get_piece_at(pos).nil? || board.get_piece_at(pos).color != color)
  end

  # Method to check if the piece is currently pinned (cannot move without exposing its king to check)
  def pinned?(board)
    # Logic to check if moving this piece would leave the king in check
    # This would involve simulating the move, checking if the king is in check, and then reversing the move
    false
  end

  # Method to calculate directional moves, used for pieces like Rook, Bishop, and Queen
  def directional_moves(board, directions)
    row, col = position
    possible_moves = []

    directions.each do |dx, dy|
      new_pos = [row + dx, col + dy]
      while within_bounds?(new_pos) && valid_move?(board, new_pos)
        possible_moves << new_pos
        break if board.get_piece_at(new_pos) # Stop if capturing a piece
        new_pos = [new_pos[0] + dx, new_pos[1] + dy]
      end
    end
    possible_moves
  end
end

# King Class
class King < Piece
  def symbol
    color == 'white' ? "\u2654" : "\u265A"
  end

  def valid_moves(board)
    possible_moves = []
    row, col = position
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]

    directions.each do |dx, dy|
      new_pos = [row + dx, col + dy]
      possible_moves << new_pos if valid_move?(board, new_pos)
    end
    possible_moves
  end
end

# Queen Class
class Queen < Piece
  def symbol
    color == 'white' ? "\u2655" : "\u265B"
  end

  def valid_moves(board)
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]]
    directional_moves(board, directions)
  end
end

# Rook Class
class Rook < Piece
  def symbol
    color == 'white' ? "\u2656" : "\u265C"
  end

  def valid_moves(board)
    directions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    directional_moves(board, directions)
  end
end

# Bishop Class
class Bishop < Piece
  def symbol
    color == 'white' ? "\u2657" : "\u265D"
  end

  def valid_moves(board)
    directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    directional_moves(board, directions)
  end
end

# Knight Class
class Knight < Piece
  def symbol
    color == 'white' ? "\u2658" : "\u265E"
  end

  def valid_moves(board)
    possible_moves = []
    row, col = position
    knight_moves = [[-2, -1], [-2, 1], [2, -1], [2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2]]

    knight_moves.each do |dx, dy|
      new_pos = [row + dx, col + dy]
      possible_moves << new_pos if valid_move?(board, new_pos)
    end
    possible_moves
  end
end

# Pawn Class
class Pawn < Piece
  def symbol
    color == 'white' ? "\u2659" : "\u265F"
  end

  def valid_moves(board)
    possible_moves = []
    row, col = position
    direction = (color == 'white' ? -1 : 1)

    # Normal one-step move
    one_step = [row + direction, col]
    if board.get_piece_at(one_step).nil?
      possible_moves << one_step if valid_move?(board, one_step)
    end

    # Two-step move if the pawn is in the starting position
    if (color == 'white' && row == 6) || (color == 'black' && row == 1)
      two_step = [row + 2 * direction, col]
      if board.get_piece_at(one_step).nil? && board.get_piece_at(two_step).nil?
        possible_moves << two_step if valid_move?(board, two_step)
      end
    end

    # Diagonal capture moves
    diagonal_left = [row + direction, col - 1]
    diagonal_right = [row + direction, col + 1]

    possible_moves << diagonal_left if board.get_piece_at(diagonal_left)&.color != color && !board.get_piece_at(diagonal_left).nil?
    possible_moves << diagonal_right if board.get_piece_at(diagonal_right)&.color != color && !board.get_piece_at(diagonal_right).nil?

    possible_moves
  end
end
