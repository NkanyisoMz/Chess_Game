require_relative '../board'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#move_piece' do
    it 'moves a piece to a valid position' do
      board.move_piece([6, 4], [4, 4]) # Move white pawn from e2 to e4
      expect(board.get_piece_at([4, 4])).not_to be_nil
    end

    it 'raises an error for an invalid move' do
      expect { board.move_piece([6, 4], [3, 4]) }.to raise_error("Invalid move")
    end
  end
end
