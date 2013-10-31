class VenuesController < ApplicationController
  def new
  end

  def index
    @venues = Venue.all
  end
end
