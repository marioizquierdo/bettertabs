require 'spec_helper'

describe "Bettertabs requests" do
  describe "GET /bettertabs/static" do
    it "has a 200 status code" do
      get '/bettertabs/static'
      response.status.should be(200)
    end
    
    it "should render all content even for hidden tabs" do
      get '/bettertabs/static'
      response.body.should include("Content for tab1")
      response.body.should include("Content for tab2")
      response.body.should include("tab_content partial content")
    end
  end
  
  describe "GET /bettertabs/link_tab_1" do
    it "has a 200 status code" do
      get '/bettertabs/link_tab_1'
      response.status.should be(200)
    end
  end

  describe "GET /bettertabs/link_tab_2" do
    it "has a 200 status code" do
      get '/bettertabs/link_tab_2'
      response.status.should be(200)
    end
  end

  describe "GET /bettertabs/ajax" do
    it "has a 200 status code" do
      get '/bettertabs/ajax'
      response.status.should be(200)
    end
  end
  
  describe "GET /bettertabs/mixed" do
    it "has a 200 status code" do
      get '/bettertabs/mixed'
      response.status.should be(200)
    end
  end
  
  describe "GET /bettertabs/mixed_with_erb" do
    it "has a 200 status code" do
      get '/bettertabs/mixed_with_erb'
      response.status.should be(200)
    end
  end 

  
end
