require 'spec_helper'

describe "StaticPages" do

  describe "Home" do
    it "should have the base title" do
      visit '/static_pages/home'
      expect( page ).to have_selector('title', text: full_title())
      expect( page ).not_to have_selector('title', text: '|')
    end
  end
end
