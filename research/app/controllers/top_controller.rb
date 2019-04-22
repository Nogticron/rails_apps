class TopController < ApplicationController

  def show
    @events = Event.all 
    @lines = Line.all
  end

end