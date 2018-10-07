require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryBot.create :user }
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:style) {FactoryBot.create :style }


  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end
  
  it "can be added if name not empty" do
    visit new_beer_path

    fill_in('beer[name]', with:'Karhu')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    expect(page).to have_content "Beer was successfully created."
  end

  it "won't be added if name is empty" do
    visit new_beer_path

    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    click_button "Create Beer"

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to be(0)
  
  end
end