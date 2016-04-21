class AdminSessionsController < ApplicationController
  def new
  end
  
  def create
    admin = Admin.find_by(uin: params[:session][:uin])
    if admin && admin.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in admin
      redirect_to admin
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid UIN or Name !' # Not quite right!
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end