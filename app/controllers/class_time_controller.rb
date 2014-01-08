class ClassTimeController < ApplicationController
  def destroy
    @class_time=ClassTime.find(params[:id])
    @class_time.destroy
    render :json=>{:success=>true}
  end
end
