class Api::EventsController < ApplicationController
  respond_to :json

  def index
    if params[:page]
      @events = Event.get_week(params[:page]).includes_venue_series
    elsif params[:active_dates]
      @dates = Event.get_active_dates(params[:from], params[:to])
    elsif params[:from] && params[:to]
      @events = Event.get_range_between(params[:from], params[:to]).includes_venue_series
    elsif params[:from]
      @events = Event.get_range(params[:from], 7).includes_venue_series
    else
      @events = Event.this_week.includes_venue_series
    end

    if @dates
      render json: @dates, each_serializer: DateSerializer
    else
      respond_with @events
    end
  end

  def show
    @event = Event.find(params[:id])
    respond_with @event
  end
end
