require_relative '../game'
require_relative '../board'
require_relative '../player'

RSpec.describe Game do
  let(:game) { Game.new }
  let(:white_player) { game.players[:white] }
  let(:black_player) { game.players[:black] }

  describe '#initialize' do
    it 'initializes a board' do
      expect(game.board).to be_an_instance_of(Board)
    end

    it 'initializes two players' do
      expect(game.players[:white]).to be_an_instance_of(Player)
      expect(game.players[:black]).to be_an_instance_of(Player)
    end

    it 'sets the current player to white' do
      expect(game.current_player.color).to eq('white')
    end
  end

  describe '#switch_turn' do
    it 'switches the current player from white to black' do
      game.switch_turn
      expect(game.current_player).to eq(black_player)
    end

    it 'switches the current player from black to white' do
      game.switch_turn
      game.switch_turn
      expect(game.current_player).to eq(white_player)
    end
  end

  describe '#handle_move' do
    before do
      allow(white_player).to receive(:get_move).and_return([[6, 4], [4, 4]]) # e2 to e4
    end

    it 'moves a piece on the board' do
      game.handle_move(white_player.get_move)
      expect(game.board.get_piece_at([4, 4])).not_to be_nil
      expect(game.board.get_piece_at([6, 4])).to be_nil
    end
  end

  describe '#save_game' do
    it 'saves the game state to a file' do
      expect(File).to receive(:open).with('saved_game.yaml', 'w')
      game.save_game
    end
  end

  describe '.load_game' do
    it 'loads the game from a file' do
      saved_data = "--- !ruby/object:Game\nboard: !ruby/object:Board\n"
      allow(File).to receive(:read).with('saved_game.yaml').and_return(saved_data)
      loaded_game = Game.load_game
      expect(loaded_game).to be_a(Game)
    end
  end
end
