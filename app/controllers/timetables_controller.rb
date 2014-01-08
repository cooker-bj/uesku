class TimetablesController < ApplicationController
  # GET /timetables
  # GET /timetables.json
  before_filter :authenticate_user!
  respond_to :html,:json
  def index
    @lesson=Lesson.find(params[:lesson_id])
    @timetables = @lesson.timetables.all

    respond_with [@lesson,@timetables]
  end

  # GET /timetables/1
  # GET /timetables/1.json
  def show
    @timetable = Timetable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timetable }
    end
  end

  # GET /timetables/new
  # GET /timetables/new.json
  def new
    @timetable = Timetable.new(:lesson_id=>params[:lesson_id])
    @timetable.class_times.build
    respond_with @timetable

  end

  # GET /timetables/1/edit
  def edit
    @timetable = Timetable.find(params[:id])
  end

  # POST /timetables
  # POST /timetables.json
  def create
    @timetable = Timetable.new(params[:timetable])
    @timetable.save
    respond_with [@timetable.lesson,@timetable]
  end

  # PUT /timetables/1
  # PUT /timetables/1.json
  def update
    @timetable = Timetable.find(params[:id])

    respond_to do |format|
      if @timetable.update_attributes(params[:timetable])
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

    respond_with [:lesson,@timetable]
  end
end
