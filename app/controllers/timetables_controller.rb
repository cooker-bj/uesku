class TimetablesController < ApplicationController
  # GET /timetables
  # GET /timetables.json
  before_filter :authenticate_user!
  respond_to :html
  layout :set_layout
  def index
    @lesson=Lesson.find(params[:lesson_id])
    @timetables = @lesson.timetables.all

    respond_with [@lesson,@timetables]
  end

  # GET /timetables/1
  # GET /timetables/1.json
  def show
    @timetable = Timetable.find(params[:id])
     respond_with @timetable
    
  end

  # GET /timetables/new
  # GET /timetables/new.json
  def new
    @timetable = Timetable.new(:lesson_id=>params[:lesson_id])
    @timetable.class_times.build(:name=>@timetable.lesson_name)
    respond_with @timetable

  end

  # GET /timetables/1/edit
  def edit
    @timetable = Timetable.find(params[:id])
    respond_with @timetable
  end

  # POST /timetables
  # POST /timetables.json
  def create
    @timetable = Timetable.new(timetable_params)
    @timetable.save
    respond_with [@timetable.lesson,@timetable]
  end

  # PUT /timetables/1
  # PUT /timetables/1.json
  def update
    @timetable = Timetable.find(params[:id])

    respond_to do |format|
      if @timetable.update_attributes(timetable_params)
        format.html { redirect_to @timetable, notice: 'Timetable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetables/1
  # DELETE /timetables/1.json
  def destroy
    @timetable = Timetable.find(params[:id])
    @timetable.destroy

    respond_with [@timetable.lesson,@timetable]
  end

  def register_user
    @timetable=Timetable.find(params[:id])
    respond_with do |format|
      if @timetable.register(current_user)
       format.html {redirect_to current_user }
        format.json {head :no_content}
      else
        format.html {render action: 'show'}
        format.json {render json:@timetime.errors,status: :unprocessable_entity}
      end
    end

  end

  def withdraw_user
    @timetable=Timetable.find(params[:id])
    respond_with do |format|
      if @timetable.unregister(current_user)
        flash[:notice]='已成功删除课表'
       format.html {redirect_to current_user }
        format.json {head :no_content}
      else
        flash[:notice]='删除课表失败'
        format.html {redirect_to current_user}
        format.json {render json:@timetime.errors,status: :unprocessable_entity}
      end
    end
    
  end

  def edit_calendar
    @timetable = Timetable.find(params[:id])
    respond_with @timetable
  end

  def remove_class_time
    class_time=ClassTime.find(params[:class_time_id])
    @timetable=Timetable.find(params[:id])
    class_time.remove_class_time(params[:start])
    render :json=>{:success=>true,:id=>@timetable.id}
  end

  def update_class_time
    @timetable=Timetable.find(params[:id])
    class_time=ClassTime.find(params[:event_id])
    class_time.modify(params[:start],params)
    respond_with @timetable,:location=>timetable_path(@timetable)
  end
  private
  def timetable_params
    params.required(:timetable).permit(:create_time, :creator_id, :description, :end_day, :lesson_id, :start_day, :title,:description,:class_times_attributes=>[:end_time_hour,:end_time_minute, :start_time_hour,:start_time_minute,:week,:start_day,:end_day,:name, :timetable_id,:_destroy])
  end

end
