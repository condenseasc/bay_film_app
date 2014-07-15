require 'spec_helper'

describe "StaticPages" do

  describe "Home" do
    it "uses the base title" do
      visit root_path
      expect( page ).to have_title( "Projection Zone" )
      expect( page ).not_to have_title( "|" )
    end
  end

  describe "Contact" do
    it "title contains base | contact" do
      visit '/contact'
      expect( page ).to have_title( "Projection Zone | Contact" )
    end
  end
end