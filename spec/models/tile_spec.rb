require 'rails_helper'

RSpec.describe Tile do
  subject { Tile.new(x: 0, y: 1) }

  describe '#inv' do
    it 'returns x when given y and vice-versa' do
      expect(subject.inv(:x)).to eq(y: subject.y)
      expect(subject.inv(:y)).to eq(x: subject.x)
    end
  end

  describe '#exists?' do
    let(:the_game) { Game.new.tap(&:save!) }
    let(:player_one) { User.new.tap(&:save!) }
    let(:player_two) { User.new.tap(&:save!) }
    let(:test_play) { Play.new(game: the_game, user: player_one).tap(&:save) }
    before do
      Play.new(game: the_game, user: player_one).tap do |p|
        p.tiles_at  [[0, 0], [0, -1], [0, -2], [0, -3]]
        p.save!
      end
    end

    it 'return true if exist :)' do
      tile = test_play.tiles.build(x: 0, y: 0)
      expect(tile.exists?).to be_truthy
    end

    it 'return false, tile not exist' do
      tile = test_play.tiles.build(x: 100, y: 100)
      expect(tile.exists?).to be_falsey
    end

  end

end
