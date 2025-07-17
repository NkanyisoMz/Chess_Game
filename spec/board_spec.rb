require_relative '../lib/board'
require_relative '../lib/piece'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'sets up an 8x8 grid with pieces in correct positions' do
      expect(board.grid[1][0]).to be_a(Pawn).and have_attributes(color: 'black')
      expect(board.grid[6][0]).to be_a(Pawn).and have_attributes(color: 'white')
      expect(board.grid[0][4]).to be_a(King).and have_attributes(color: 'black')
      expect(board.grid[7][4]).to be_a(King).and have_attributes(color: 'white')
    end
  end

  describe '#move_piece' do
    it 'moves a piece to a valid position' do
      board.move_piece([6, 4], [4, 4], 'white') # Move white pawn from e2 to e4
      expect(board.get_piece_at([4, 4])).to be_a(Pawn).and have_attributes(color: 'white')
      expect(board.get_piece_at([6, 4])).to be_nil
    end

    it 'raises an error for an invalid move' do
      expect { board.move_piece([6, 4], [3, 4], 'white') }.to raise_error(/Invalid move/)
    end

    it 'raises an error when moving opponent\'s piece' do
      expect { board.move_piece([1, 4], [3, 4], 'white') }.to raise_error(/opponent's piece/)
    end

    it 'raises an error for empty starting position' do
      expect { board.move_piece([4, 4], [3, 4], 'white') }.to raise_error(/No piece found/)
    end
  end

  describe '#in_check?' do
    it 'returns false for initial board setup' do
      expect(board.in_check?('white')).to be false
      expect(board.in_check?('black')).to be false
    end
  end
end
