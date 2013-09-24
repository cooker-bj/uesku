class MyLessonsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  def index
    @my_lessons = MyLesson.where(:creator_id=>current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_lessons }
    end
  end

  # GET /my_lessons/1
  # GET /my_lessons/1.json
  def show
    @my_lesson = MyLesson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_lesson }
    end
  end

  # GET /my_lessons/new
  # GET /my_lessons/new.json
  def new
    @my_lesson = MyLesson.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_lesson }
    end
  end

  # GET /my_lessons/1/edit
  def edit
    @my_lesson = MyLesson.find(params[:id])
  end

  # POST /my_lessons
  # POST /my_lessons.json
  def create
    @my_lesson = MyLesson.new(params[:my_lesson])

    respond_to do |format|
      if @my_lesson.save
        format.html { redirect_to @my_lesson, notice: 'My lesson was successfully created.' }
        format.json { render json: @my_lesson, status: :created, location: @my_lesson }
      else
        format.html { render action: "new" }
        format.json { render json: @my_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_lessons/1
  # PUT /my_lessons/1.json
  def update
    @my_lesson = MyLesson.find(params[:id])

    respond_to do |format|
      if @my_lesson.update_attributes(params[:my_lesson])
        format.html { redirect_to @my_lesson, notice: 'My lesson was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_lessons/1
  # DELETE /my_lessons/1.json
  def destroy
    @my_lesson = MyLesson.find(params[:id])
    @my_lesson.destroy

    respond_to do |format|
      format.html { redirect_to my_lessons_url }
      format.json { head :no_content }
    end
  end
end
