require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    canned_answer = <<-END_OF_STRING
    {"location":{"name":"Kumpula","region":"Lapland","country":"Finland","lat":66.67,"lon":27.58,"tz_id":"Europe/Helsinki","localtime_epoch":1539462827,"localtime":"2018-10-13 23:33"},"current":{"last_updated_epoch":1539462611,"last_updated":"2018-10-13 23:30","temp_c":10.0,"temp_f":50.0,"is_day":0,"condition":{"text":"Mist","icon":"//cdn.apixu.com/weather/64x64/night/143.png","code":1030},"wind_mph":6.9,"wind_kph":11.2,"wind_degree":190,"wind_dir":"S","pressure_mb":1009.0,"pressure_in":30.3,"precip_mm":0.0,"precip_in":0.0,"humidity":100,"cloud":75,"feelslike_c":8.4,"feelslike_f":47.2,"vis_km":2.3,"vis_miles":1.0}}
    END_OF_STRING

    stub_request(:get, /.*kumpula/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/json" })

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

    canned_answer = <<-END_OF_STRING
    {"location":{"name":"Kumpula","region":"Lapland","country":"Finland","lat":66.67,"lon":27.58,"tz_id":"Europe/Helsinki","localtime_epoch":1539462827,"localtime":"2018-10-13 23:33"},"current":{"last_updated_epoch":1539462611,"last_updated":"2018-10-13 23:30","temp_c":10.0,"temp_f":50.0,"is_day":0,"condition":{"text":"Mist","icon":"//cdn.apixu.com/weather/64x64/night/143.png","code":1030},"wind_mph":6.9,"wind_kph":11.2,"wind_degree":190,"wind_dir":"S","pressure_mb":1009.0,"pressure_in":30.3,"precip_mm":0.0,"precip_in":0.0,"humidity":100,"cloud":75,"feelslike_c":8.4,"feelslike_f":47.2,"vis_km":2.3,"vis_miles":1.0}}
    END_OF_STRING

    stub_request(:get, /.*kumpula/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/json" })

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