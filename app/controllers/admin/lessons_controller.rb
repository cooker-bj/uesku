#--encoding: UTF-8
class Admin::LessonsController <Admin::AdminBaseController
  respond_to :html

  def index
   
    @lessons=Lesson.paginate(:page=>params[:page],:per_page=>20)
    
  end

  def show
    @lesson=Lesson.find(params[:id])
  end

  

  
end