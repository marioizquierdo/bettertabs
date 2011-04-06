require 'spec_helper'

describe "Bettertabs" do
  describe "GET /home" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get home_index_path
      response.status.should be(200)
      response.body.should include("Hello World!")
      response.body.should_not include("dark side")
    end
  end
end
