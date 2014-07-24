class Api::DaysController < ApplicationController
  respond_to :json

  def index
  end

  def show
    @day = Day.find(params[:id])
    render json: @day, serializer: DaySerializer
  end
end
