class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3,
                                                   maximum: 30 }
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{3,}\z/ }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
end
