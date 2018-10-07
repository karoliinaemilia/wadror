class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery
  belongs_to :style

  validates :name, presence: true
  validates :style_id, presence: true

  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def to_s
    "#{name} - #{brewery.name}"
  end
end
