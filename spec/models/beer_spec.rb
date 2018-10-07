require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "that" do
    let!(:test_brewery) { Brewery.create name: "test", year: 2000 }
    let!(:test_style) { Style.create name: "teststyle", description: "a style" }

    it "has a brewery, a name and a style, is saved" do
      beer = Beer.create name: "testbeer", style: test_style, brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "doesn't have a name isn't saved" do
      beer = Beer.create style: test_style, brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "doesn't have a style isn't saved" do
      beer = Beer.create name: "testbeer", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
