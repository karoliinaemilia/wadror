require 'rails_helper'

include Helpers

describe "User" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", style:"Weizen", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Pekka2" }
  let!(:rating1) { FactoryBot.create :rating, beer:beer2, user: user, score: 10 }
  let!(:rating2) { FactoryBot.create :rating, beer:beer2, user: user, score: 40 }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
        sign_in(username: "Pekka", password: "wrong")
  
        expect(current_path).to eq(signin_path)
        expect(page).to have_content 'Username and/or password mismatch'
      end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "is shown on the user's page" do
    FactoryBot.create :rating, beer:beer2, user: user2, score: 50
    visit user_path(user)

    expect(page).to have_content "#{rating1}"
    expect(page).to have_content "#{rating2}"
    expect(page).not_to have_content "#{beer2.name} 50"
  end

  it "can be deleted by user who made it" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(user)
    

    page.find('li', text: "#{rating1}").click_link('delete')

    expect(page).not_to have_content "#{rating1}"
    expect(Rating.count).to be(1)
  end

  it "has favorite style listed" do
    visit user_path(user)
    expect(page).to have_content "Favorite style is #{user.favorite_style}"
  end

  it "has favorite brewery listed" do
    FactoryBot.create :rating, beer:beer1, user: user, score: 50
    visit user_path(user)
    expect(page).to have_content "Favorite brewery is #{user.favorite_brewery.name}"
  end
end