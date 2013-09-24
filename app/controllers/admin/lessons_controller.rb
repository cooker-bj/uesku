#--encoding: UTF-8
class Admin::LessonsController <Admin::AdminBaseController

  def index
    @lessons=Hash.new
    @lessons['unaudited']=Lesson.un_audit_all
    @lessons['audited']=Lesson.audit_all
  end

  def show
    @lesson=Lesson.find(params[:id])
  end

  def set_audit
    @lesson=Lesson.find(params[:id])
    @lesson.set_audit
    redirect_to admin_lessons_path
  end

  def withdraw_audit
    @lesson=Lesson.find(params[:id])
    flash[:notice]= '已取消审批'if @lesson.withdraw_audit
    redirect_to admin_lessons_path
  end

  def list
    @lesson=Lesson.audit_all.paginate(:params=>:page,:per_page=>40)
  end
end