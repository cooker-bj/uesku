class MainController < ApplicationController
  
  def index
    respond_to do |format|
      format.html do |html|
        html.phone
        html
      end
    end
  end

 
  
end
