class UsersController < ApplicationController
  def index
    # @msg = { "success" => "true", "message" => "hello"}
 
   
    @locations = ["medio campidano", "cagliari", "oristano", "nuoro", "sassari","sardegna", "sardegna eccetto medio campidano", "altro"]
    #@locations = User.distinct.pluck(:place) + @basic_locations
    #@locations.uniq!
    
    @location = "medio campidano"
    
    if params[:locations]
      @location = params[:locations].downcase!
      logger.debug "@location: #{@location}"
    end  
    
    @users = User.where(place: @location)
    if @location == "sardegna"
      @users = User.all
    elsif @location == "sardegna eccetto medio campidano"
      @users = User.where.not(place: 'medio campidano')
      logger.debug "eccetto: #{@users.length}"
    elsif @location == "altro"
      @users = User.where.not(place: @locations)
    end  
    
    logger.debug("location param: #{@location}")
    #@locations = @locations.compact!
    #binding.pry
    
    # all_users = User.where(place: @location).count
    # @males = User.where(place: @location, sex: 'M').count
    # @females = all_users - @males
    
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
  
