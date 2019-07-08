class UsersController < ApplicationController
  def index
    # @msg = { "success" => "true", "message" => "hello"}
 
   
    @users = User.all
    @locations = User.distinct.pluck(:place) +  ["cagliari", "oristano", "nuoro", "sassari","sardegna", "sardegna eccetto medio campidano", "altro"]
    
    @location = "Medio Campidano"
    if params[:locations]
      @location = params[:locations]
    end  
    
    
    logger.debug("location param: #{@location}")
    #@locations = @locations.compact!
    #binding.pry
    
    all_users = User.count
    @males = User.where(sex: 'M').count
    @females = all_users - @males
    
    respond_to do |format|
       if request.xhr?
          logger.debug "XHR request"
          logger.debug "ajax param: #{@location}"
          format.js 
       else  
        format.html
       end  

    end
    #   format.json { render json: @msg }
    end
end    
    
    

  
  # def users_by_age
  
  # end  
  
