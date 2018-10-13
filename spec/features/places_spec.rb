require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by API, they are shown on the page" do
    breweries = ["Oljenkorsi", "Stadin Panimo", "Panimoravintola Bruuveri", "Brewdog Helsinki"]
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name: breweries[0], id: 1 ),
          Place.new( name: breweries[1], id: 2 ),
          Place.new( name: breweries[2], id: 3 ),
          Place.new( name: breweries[3], id: 4 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    breweries.each do |brewery_name|
      expect(page).to have_content brewery_name
    end
  end

  it "if none are returned by API, notice is shown" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      []
    )

    city = 'kumpula'
    visit places_path
    fill_in('city', with: city)
    click_button "Search"

    expect(page).to have_content "No locations in #{city}"
  end
end