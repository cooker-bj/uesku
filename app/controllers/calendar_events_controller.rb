class CalendarEventsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html,:json
  layout :set_layout
  def index
    @events=current_user.calendar_events.range(params[:start],params[:end])
    respond_with @events,:layout=>false
  end

  def new
    @event=CalendarEvent.new
    @event.alerts.build
    respond_with @event, :layout=>false 
  end

  def edit
    @event=CalendarEvent.find(params[:id])
    respond_with @event, :layout=>false 
  end

  def show
    @event=CalendarEvent.find(params[:id])
    respond_with @event,:layout=>false 
  end

  def create

    if @events=CalendarEvent.add_events(calendar_event_params,params[:repeat_params])
    
      render :json=>{:success=>true,:events=>@events}
    else
      render :json=>{:success=>false,:error=>" wrong arguments",:status=>:unprocessable_entity}
    end

  end

  def update
    if @events=CalendarEvent.update_events(params[:id],calendar_event_params,params[:applied_to_all])
       render :json=>{:success=>true,:events=>@events}
    else
      render :json=>{:success=>false,:error=>" wrong arguments",:status=>:unprocessable_entity}
    end

  end

  def destroy
    @events=CalendarEvent.remove_events(params[:id],params[:my_scope])
   
    render :json=>{:success=>true,:events=>@events} 
  end
  
  private
    
  def calendar_event_params
    params.required(:calendar_event).permit(:description, :end_time, :event_group_id, :location, :source, :start_time, :title,:user_id,:all_day,:repeat,:timetable_name,:alerts_attributes=>[:_destroy,:id,:alert_before_event, :calendar_event_id, :when_to_alert])
  end

end
