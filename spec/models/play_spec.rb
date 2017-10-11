require 'rails_helper'

RSpec.describe Play do
  let(:the_game) { Game.new.tap(&:save!) }
  let(:player_one) { User.new.tap(&:save!) }
  let(:player_two) { User.new.tap(&:save!) }

  let(:first_play) do
    Play.new(game: the_game, user: player_one).tap do |p|
      p.tiles_at  [[0, 0], [0, -1], [0, -2], [0, -3]]
      p.save!
    end
  end

  subject { Play.new(game: the_game, user: player_two) }

  describe '#tiles_at' do
    it 'replaces all tiles with new tiles at coordinates' do
      subject.tiles_at [[0, 1], [0, 2]]

      expect(subject.tiles.size).to eq 2
      expect(subject.tiles.map(&:x)).to match_array([0, 0])
      expect(subject.tiles.map(&:y)).to match_array([1, 2])
    end
  end

  context 'not touching anything' do
    before { subject.tiles_at  [[9, 9]] }

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with an adjacent previous tile' do
    before do
      first_play
      subject.tiles_at  [[1, 0], [2, 0], [3, 0]]
    end

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'with spaces missing' do
    before { subject.tiles_at [[-1, 0], [1, 0], [2, 0]] }

    it 'is invalid' do
      expect(subject).not_to be_valid
    end

    context 'made contiguous by an existing tile' do
      before { first_play }
      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end

  context 'overlapping an existing tile' do
    before do
      first_play
      subject.tiles_at [[-1, 0], [0, 0], [0, 1]]
    end

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with non-linear y placement' do
    before { subject.tiles_at  [[0, 0], [0, -1], [1, -2]] }

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with non-linear x placement' do
    before { subject.tiles_at  [[0, 0], [1, 1], [2, 0]] }

    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with linear placement' do
    before { subject.tiles_at  [[0, 0], [0, 1], [0, 2]] }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
