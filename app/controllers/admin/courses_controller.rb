#--*-- encoding: UTF-8
class Admin::CoursesController< Admin::AdminBaseController
  respond_to :html,:json
  def index
    @company=Company.find(params[:company_id])
    @courses=@company.courses.paginate(:page=>params[:page],:per_page=>20)
    respond_with [:admin,@course]

  end

  def new
    @course=Course.new(:company_id=>params[:company_id])

    respond_with [:admin,@course.company,@course]
  end

  def edit
    @course=Course.find(params[:id])
    respond_with [:admin,@course.company,@course]
  end

  def show
    @course=Course.find(params[:id])
    respond_with [:admin,@course.company,@course]
  end

   def create
     @course=Course.new(params[:course])
     flash[:notice]="已保存" if @course.save
     respond_with [:admin,@course.company,@course]
   end

    def update
      @course=Course.find(params[:id])
      flash[:notice]="已更新"  if @course.update_attributes(params[:course])
      respond_with [:admin,@course.company,@course]

    end

    def destroy
      @course=Course.find(params[:id])
      @course.destroy
      respond_with [:admin,@course.company,@course]
    end



end