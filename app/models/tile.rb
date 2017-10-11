class Tile < ApplicationRecord
  belongs_to :play

  def exists?
    self.play.game.plays.includes(:tiles).where(tiles: {x: self.x, y: self.y}).count > 0
  end

  def adjacent
    self.play.other_tiles.
      where(x: self.x + 1, y: self.y).
      or(self.play.other_tiles.where(x: self.x - 1, y: self.y)).
      or(self.play.other_tiles.where(x: self.x, y: self.y + 1)).
      or(self.play.other_tiles.where(x: self.x, y: self.y - 1))
  end

  def center?
    x == 0 && y == 0
  end

  def inv(x_or_y)
    x_or_y == :x ? { y: y } : { x: x }
  end

  def overlaps_any?(tiles)
    tiles.any? { |m| m.x == x && m.y == y }
  end

  def any_adjacent?
    adjacent.count > 0
  end

end
