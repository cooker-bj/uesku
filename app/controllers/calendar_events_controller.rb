class CalendarEventsController < ApplicationController
  respond_to :html,:json
  def index
    @events=current_user.calendar_events
    respond_with @events
  end

  def new
    @event=CalendarEvent.new
    @event.notifications.build
    respond_with @event, :layout=>false if request.xhr?
  end

  def edit
    @event=CalendarEvent.find(params[:id])
    respond_with @event, :layout=>false if request.xhr?
  end

  def show
    @event=CalendarEvent.find(params[:id])
    respond_with @event,:layout=>false if request.xhr?
  end

  def create

    if @events=CalendarEvent.add_events(params[:calendar_event],(params[:repeat].blank? ? nil :params[:repeat_params]))
    
      render :json=>{:success=>true,:events=>@events}
    else
      render :json=>{:success=>false,:error=>" wrong arguments",:status=>:unprocessable_entity}
    end

  end

  def update
    if @events=CalendarEvent.update_events(params[:id],params[:calendar_event],params[:applied_to_all])
       render :json=>{:success=>true,:events=>@events}
    else
      render :json=>{:success=>false,:error=>" wrong arguments",:status=>:unprocessable_entity}
    end

  end

  def destroy
    @events=CalendarEvent.remove_events(params[:id],params[:my_scope])
   
    render :json=>{:success=>true,:events=>@events} 
  end
end
