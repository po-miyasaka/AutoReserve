# frozen_string_literal: true

require "./spec/spec_helper.rb"
require "./dmm_lib.rb"

RSpec.describe "dmm_lib" do
  describe "#generate_url_string" do
    context "favorite is true" do
      it "works" do
        expected = "https://eikaiwa.dmm.com/list/?&data[tab1][start_time]=22:00&data[tab1][end_time]=22:00&data[tab1][native]=1&data[tab1][favorite]=on&date=2020-02-03&sort=6"
        expect(generate_url_string("2020-02-03", "22:00", true)).to eq(expected)
      end
    end

    context "favorite is false" do
      it "works" do
        expected = "https://eikaiwa.dmm.com/list/?&data[tab1][start_time]=22:30&data[tab1][end_time]=22:30&data[tab1][native]=1&date=2021-02-30&sort=6"
        expect(generate_url_string("2021-02-30", "22:30", false)).to eq(expected)
      end
    end
  end
end
