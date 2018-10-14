class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(length)
    Style.all.sort_by{ |b| -(b.average_rating || 0) }.first(length)
  end
end
