require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "that" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }

    it "has a brewery, a name and a style, is saved" do
      beer = Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "doesn't have a name isn't saved" do
      beer = Beer.create style: "teststyle", brewery: test_brewery

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
