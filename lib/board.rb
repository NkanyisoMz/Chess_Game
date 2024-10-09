require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    # Initialize an 8x8 grid, where each element is either a piece or nil
    @grid = Array.new(8) { Array.new(8, nil) }

    # Add pieces to their starting positions
    setup_pieces
  end

  def setup_pieces
    # Place pawns
    (0..7).each do |i|
      @grid[1][i] = Pawn.new('black', [1, i]) # Black pawns
      @grid[6][i] = Pawn.new('white', [6, i]) # White pawns
    end

    # Place back row pieces
    setup_back_row(0, 'black') # Black back row
    setup_back_row(7, 'white') # White back row
  end

  def setup_back_row(row, color)
    @grid[row][0] = Rook.new(color, [row, 0])
    @grid[row][1] = Knight.new(color, [row, 1])
    @grid[row][2] = Bishop.new(color, [row, 2])
    @grid[row][3] = Queen.new(color, [row, 3])
    @grid[row][4] = King.new(color, [row, 4])
    @grid[row][5] = Bishop.new(color, [row, 5])
    @grid[row][6] = Knight.new(color, [row, 6])
    @grid[row][7] = Rook.new(color, [row, 7])
  end

  def get_piece_at(position)
    x, y = position
    return nil if x.nil? || y.nil? || x < 0 || x > 7 || y < 0 || y > 7 # Ensure valid grid position
    @grid[x][y] # Access the piece at position
  end

  def move_piece(from_pos, to_pos, current_player_color)
    piece = get_piece_at(from_pos)
  
    if piece.nil?
      puts "No piece found at #{from_pos}. Invalid move."
      return
    end
  
    if piece.color != current_player_color
      puts "You cannot move the opponent's piece!"
      return
    end
  
    x, y = to_pos
    # Move the piece to the new position
    @grid[x][y] = piece
    @grid[from_pos[0]][from_pos[1]] = nil # Clear the original position
    piece.position = to_pos # Update the piece's position
  end

  # In Board class
def checkmate?(color)
  return false unless in_check?(color)

  # Iterate through all pieces of the current player
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |piece, col_index|
      next if piece.nil? || piece.color != color

      # Get all possible moves for this piece
      piece_possible_moves = piece.possible_moves

      # Simulate each move to see if it can remove the check
      piece_possible_moves.each do |move|
        from_pos = [row_index, col_index]
        to_pos = move

        if move_removes_check?(from_pos, to_pos, color)
          return false # If a valid move is found, it's not checkmate
        end
      end
    end
  end

  true # If no valid moves found, it is checkmate
end

def in_check?(color)
  # Find the king
  king_pos = find_king(color)

  # Check if any opposing piece can attack the king
  @grid.each do |row|
    row.each do |piece|
      next if piece.nil? || piece.color == color

      return true if piece.possible_moves.include?(king_pos)
    end
  end

  false
end

def find_king(color)
  @grid.each_with_index do |row, row_index|
    row.each_with_index do |piece, col_index|
      return [row_index, col_index] if piece.is_a?(King) && piece.color == color
    end
  end

  raise "King not found for color #{color}" # King should always exist
end

# Simulate the move and check if it removes the check
def move_removes_check?(from_pos, to_pos, color)
  # Temporarily move the piece
  original_piece = @grid[to_pos[0]][to_pos[1]]
  piece = @grid[from_pos[0]][from_pos[1]]
  @grid[to_pos[0]][to_pos[1]] = piece
  @grid[from_pos[0]][from_pos[1]] = nil
  piece.position = to_pos

  # Check if the king is still in check after the move
  still_in_check = in_check?(color)

  # Revert the move
  @grid[from_pos[0]][from_pos[1]] = piece
  @grid[to_pos[0]][to_pos[1]] = original_piece
  piece.position = from_pos

  !still_in_check
end

  
end
