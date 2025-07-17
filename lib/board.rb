require_relative 'piece'

class Board
  attr_accessor :grid

  def initialize
    # Initialize an 8x8 grid, where each element is either a piece or nil
    @grid = Array.new(8) { Array.new(8, nil) }
    setup_pieces
  end

  def setup_pieces
    (0..7).each do |i|
      @grid[1][i] = Pawn.new('black', [1, i]) # Black pawns
      @grid[6][i] = Pawn.new('white', [6, i]) # White pawns
    end
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
    return nil unless position && position.length == 2
    x, y = position
    return nil if x.nil? || y.nil? || x < 0 || x > 7 || y < 0 || y > 7
    @grid[x][y]
  end

  def move_piece(from_pos, to_pos, current_player_color)
    piece = get_piece_at(from_pos)
    unless piece
      raise "No piece found at #{from_pos}. Invalid move."
    end

    unless piece.color == current_player_color
      raise "You cannot move the opponent's piece!"
    end

    unless piece.valid_moves(self).include?(to_pos)
      raise "Invalid move for #{piece.class} from #{from_pos} to #{to_pos}."
    end

    # Check if the move puts the player's own king in check
    if move_causes_check?(from_pos, to_pos, current_player_color)
      raise "Move would place your king in check!"
    end

    # Perform the move
    x, y = to_pos
    @grid[x][y] = piece
    @grid[from_pos[0]][from_pos[1]] = nil
    piece.position = to_pos
  end

  def checkmate?(color)
    return false unless in_check?(color)

    @grid.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        next if piece.nil? || piece.color != color

        piece.valid_moves(self).each do |move|
          from_pos = [row_index, col_index]
          return false if move_removes_check?(from_pos, move, color)
        end
      end
    end
    true
  end

  def in_check?(color)
    king_pos = find_king(color)

    @grid.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color == color
        return true if piece.valid_moves(self).include?(king_pos)
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
    raise "King not found for color #{color}"
  end

  def move_removes_check?(from_pos, to_pos, color)
    original_piece = @grid[to_pos[0]][to_pos[1]]
    piece = @grid[from_pos[0]][from_pos[1]]
    @grid[to_pos[0]][to_pos[1]] = piece
    @grid[from_pos[0]][from_pos[1]] = nil
    piece.position = to_pos

    still_in_check = in_check?(color)

    @grid[from_pos[0]][from_pos[1]] = piece
    @grid[to_pos[0]][to_pos[1]] = original_piece
    piece.position = from_pos

    !still_in_check
  end

  def move_causes_check?(from_pos, to_pos, color)
    original_piece = @grid[to_pos[0]][to_pos[1]]
    piece = @grid[from_pos[0]][from_pos[1]]
    @grid[to_pos[0]][to_pos[1]] = piece
    @grid[from_pos[0]][from_pos[1]] = nil
    piece.position = to_pos

    in_check = in_check?(color)

    @grid[from_pos[0]][from_pos[1]] = piece
    @grid[to_pos[0]][to_pos[1]] = original_piece
    piece.position = from_pos

    in_check
  end
end
