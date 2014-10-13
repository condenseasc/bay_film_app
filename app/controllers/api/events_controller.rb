class Api::EventsController < ApplicationController
  respond_to :json

  def index
    if params[:page]
      @events = Event.get_week(params[:page]).all_associations
    elsif params[:active_dates]
      @dates = Event.get_active_dates(params[:from], params[:to])
    elsif params[:from] && params[:to]
      @events = Event.get_range_between(params[:from], params[:to]).all_associations
    elsif params[:from]
      @events = Event.get_range(params[:from], 7).all_associations
    else
      @events = Event.this_week.all_associations
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
