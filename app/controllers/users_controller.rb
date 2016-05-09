class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :has_access?, only:[:show,:index]

  # GET /users
  # GET /users.json
  def index

    if params[:search]
     redirect =false
  
          if params[:membership]
            if params[:membership].length !=0
              
                 @membership = params[:membership]
                 session[:membership] = params[:membership]
            end 
       
          elsif session[:membership] && session[:membership].length != 0
              @membership = session[:membership]
              redirect =true
          else
              @membership = nil
          end
          
          if params[:classification]
    
                 @classification = params[:classification]
                 session[:classification] = params[:classification]
           
       
          elsif session[:classification] && session[:classification].length != 0
      
              @classification = session[:classification]
              redirect =true
          else
              @classification = nil
          end
          
           if params[:dynasty]
    
                 @dynasty = params[:dynasty]
                 session[:dynasty] = params[:dynasty]
           
       
          elsif session[:dynasty] && session[:dynasty].length != 0
      
              @dynasty = session[:dynasty]
              redirect =true
          else
              @dynasty = nil
           end
      
          if redirect
               redirect_to users_path(:membership =>@membership, :classification => @classification,:dynasty =>@dynasty,:search => params[:search])
          end
      
      
         if @membership && @classification && @dynasty
          
              @users = User.where(:membership =>@membership, :classification => @classification,:dynasty =>@dynasty).paginate(:page => params[:page],per_page:20) 
         elsif  @membership && @classification
              @users = User.where(:membership =>@membership,:classification => @classification).paginate(:page => params[:page],per_page:20)
              
         elsif  @membership && @dynasty
              @users = User.where(:membership =>@membership,:dynasty => @dynasty).paginate(:page => params[:page],per_page:20) 
              
         elsif @classification && @dynasty
              @users = User.where(:classification => @classification, :dynasty =>@dynasty).paginate(:page => params[:page],per_page:20)     
          
         elsif @membership 
             @users = User.where(:membership =>@membership).paginate(:page => params[:page],per_page:20)
              
         elsif @classification
              @users = User.where(:classification => @classification).paginate(:page => params[:page],per_page:20)
              
         elsif @dynasty
              @users = User.where(:dynasty => @dynasty).paginate(:page => params[:page],per_page:20)
                
         else
              @users= User.paginate(:page => params[:page],per_page:20)
         end
    else
   
       @users= User.paginate(:page => params[:page],per_page:20)
       session[:membership]=nil
       session[:classification]=nil
       session[:dynasty]=nil
    end
   
  end

  # GET /users/1
  # GET /users/1.json
  def show
   if params[:remove]
     @event = Event.find(params[:eventid])
     @event.users.delete(@user)
     redirect_to event_path(@event)
   end 
  if params[:checkin]
    @event = Event.find(params[:eventid])
  end
   @userevents =  @user.events.paginate(:page => params[:page],per_page:5)
  end
  

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if params[:checkin]
    @event = Event.find(params[:eventid])
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        flash[:success] = "Successfully created！"
        format.html { redirect_to @user}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "Successfully update！"
        format.html { redirect_to @user}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:success] = "Successfully delete！"
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def has_access?
     
    if (session[:user_id] != nil)
      if (params[:id].to_i!= session[:user_id])
        @user = User.find(session[:user_id])
       redirect_to root_url
       flash[:notice] ="you can only view your information!"
       return
      end
    
    elsif (session[:admin_id] == nil)
      flash[:notice] ="You shoud have admin access to view this information"
      redirect_to root_url
      return
    end
    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :uin, :tel, :email, :membership, :shirt, :classification, :dynasty)
    end
    
    def log_in(user)
    session[:user_id] = user.id
  end
  
  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
