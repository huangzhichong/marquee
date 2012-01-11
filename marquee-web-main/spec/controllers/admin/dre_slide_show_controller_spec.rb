require 'spec_helper'

describe Admin::DreSlideShowController do

  describe "GET 'config'" do
    it "should be successful" do
      get 'config'
      response.should be_success
    end
  end

end
