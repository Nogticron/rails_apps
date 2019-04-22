class EventsController < ApplicationController

  def index
    if params[:station].present?
      @events = Station.find(params[:station]).events.all.order(:date)
    else
      @events = Event.all.order(:date)
    end

    @stations = @events.first.stations
  end

end
