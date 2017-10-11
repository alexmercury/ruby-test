class Play < ApplicationRecord
  belongs_to :game
  belongs_to :user

  has_many :tiles, autosave: true

  validate :validate_tiles

  def other_tiles
    play_ids = self.game.plays.pluck(:id) - [self.id]
    Tile.where(play_id: play_ids)
  end

  def tile_at(x, y)
    self.tiles << Tile.new(x: x, y: y, play: self)
  end

  def tiles_at(coords)
    self.tiles = []
    coords.map { |a| self.tile_at(a[0], a[1]) }
  end

  def validate_tiles
    x_y = self.tiles.map { |t| [t.x, t.y] }
    if x_y.map(&:first).uniq.count > 1 && x_y.map(&:last).uniq.count > 1
      errors.add(:tiles, 'with non-linear (x | y) placement')
    elsif self.game.plays.count == 0
      errors.add(:tiles, 'need tile {x: 0, y: 0} position') unless Tile.new(x: 0, y:0).overlaps_any?(self.tiles)
    else
      errors.add(:tiles, 'not touching anything') unless self.tiles.any?(&:any_adjacent?)
      if self.tiles.any? { |t| t.overlaps_any?(self.other_tiles.select(:x,:y)) }
        errors.add(:tiles, 'overlapping an existing tile')
      end
    end
  end

end
