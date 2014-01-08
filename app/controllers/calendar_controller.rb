class CalendarController < ApplicationController
  respond_to :html,:json
  def index
    @events=current_user.calendar_events
    respond_with @events
  end

  def new
    @event=CalendarEvent.new
    respond_with @event
  end

  def create

  end

  def destroy
    @event=CalendarEvent.find(params[:id])
    @event.destroy
    respond_with @event
  end
end
