require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, beer:beer2, user: user, score: 10 }
  let!(:rating2) { FactoryBot.create :rating, beer:beer2, user: user, score: 40 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(2).to(3)

    expect(user.ratings.count).to eq(3)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq("15")
  end

  it "page has all ratings and their amount listed" do
    visit ratings_path
    
    expect(page).to have_content "Number of ratings: 2"
    expect(page).to have_content "#{beer2.name} 10 #{user.username}"
    expect(page).to have_content "#{beer2.name} 40 #{user.username}"
  end
end