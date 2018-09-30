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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    get_favorite(ratings.group_by{ |rating| rating.beer.style })
  end

  def get_favorite(group)
    avain = ""
    max = 0
    group.each do |key, ratings|
      if ratings.sum(&:score) / ratings.count.to_f > max
        max = ratings.sum(&:score) / ratings.count.to_f
        avain = key
      end
    end
    avain
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewerynid = get_favorite(ratings.group_by{ |rating| rating.beer.brewery.id })
    Brewery.find_by id: brewerynid
  end
end
