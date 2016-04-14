class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(name: params[:session][:name])
    if @user != nil && @user[:uin] == params[:session][:uin]
      # Log the user in and redirect to the user's show page.
      log_in @user
      redirect_to @user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid Name or UIN !' # Not quite right!
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
