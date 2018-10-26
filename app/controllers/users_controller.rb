class UsersController < ApplicationController
  def index
    @users = User.all
    all_users = User.count
    @males = User.where(sex: 'M').count
    @females = all_users - @males
    
  end
  
  # def users_by_age
  
  # end  
  
end
