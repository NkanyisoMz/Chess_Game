require_relative '../player'

RSpec.describe Player do
  let(:player) { Player.new('white') }

  describe '#initialize' do
    it 'assigns the correct color to the player' do
      expect(player.color).to eq('white')
    end
  end

  describe '#get_move' do
    before do
      allow(player).to receive(:gets).and_return('e2 e4')
    end

    it 'parses the input and returns the correct move' do
      expect(player.get_move).to eq([[6, 4], [4, 4]]) # e2 -> [6, 4], e4 -> [4, 4]
    end
  end

  describe '#convert_to_index' do
    it 'converts chess notation to array indices' do
      expect(player.convert_to_index('e2')).to eq([6, 4]) # e2 -> [6, 4]
      expect(player.convert_to_index('h8')).to eq([0, 7]) # h8 -> [0, 7]
      expect(player.convert_to_index('a1')).to eq([7, 0]) # a1 -> [7, 0]
    end
  end
end
