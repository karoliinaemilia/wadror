require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with a non-proper password" do
    it "that is too short, isn't saved" do
      user = User.create username:"Pekka", password:"Sec", password_confirmation:"Sec"
      
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
    it "that doesn't contain a number, isn't saved" do
      user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"
      
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      style = FactoryBot.create(:style)
      create_beers_with_many_ratings_and_style({user: user}, style, 10, 20, 15, 7, 9)
      best = create_beer_with_rating_and_style({ user: user }, style, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only beer rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest average score" do
      lager = FactoryBot.create(:style, name: "Lager")
      weizen = FactoryBot.create(:style, name: "Weizen")
      ipa = FactoryBot.create(:style, name: "IPA")
      create_beers_with_many_ratings_and_style({user: user}, lager, 10, 20, 15, 7, 9)
      create_beers_with_many_ratings_and_style({user: user}, weizen, 2, 30, 1, 1)
      create_beers_with_many_ratings_and_style({user: user}, ipa, 13, 2, 14)

      expect(user.favorite_style).to eq("Lager")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only beer rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest average score" do
      brewery1 = FactoryBot.create(:brewery, name: "Koff")
      brewery2 = FactoryBot.create(:brewery, name: "Karjala")

      create_beers_with_many_ratings_and_brewery({user: user}, brewery1, 10, 20, 15, 7, 9)
      create_beers_with_many_ratings_and_brewery({user: user}, brewery1, 2, 30, 1, 1)
      create_beers_with_many_ratings_and_brewery({user: user}, brewery2, 13, 2, 14)
       
      expect(user.favorite_brewery).to eq(brewery1)
    end
  end
end

def create_beer_with_rating_and_style(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beer_with_rating_and_brewery(object, score, brewery)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer 
end

def create_beers_with_many_ratings_and_brewery(object, brewery, *scores)
  scores.each do |score|
    create_beer_with_rating_and_brewery(object, score, brewery)
  end
end

def create_beers_with_many_ratings_and_style(object, style, *scores)
  scores.each do |score|
    create_beer_with_rating_and_style(object, style, score)
  end
end