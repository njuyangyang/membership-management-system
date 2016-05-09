class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :has_access?, only:[:show,:index]

  # GET /events
  # GET /events.json
  def index
  
     if params[:search]
     redirect=false

     if params[:category]
        @category=params[:category]
        session[:category]=params[:category]

     elsif session[:category]&&session[:category].length != 0
        @category=session[:category]
        redirect=true

     else
        @category=nil

     end
 
     if params[:semester]
        @semester=params[:semester]
        session[:semester]=params[:semester]
    
     elsif session[:semester]&&session[:semester].length !=0
        @semester=session[:semester]
        redirect=true

     else 
        @semester=nil

     end
    
     if params[:year]

        @year=params[:year]
        session[:year]=params[:year]

     elsif session[:year]&&session[:year].length !=0
        @year=session[:year]
        redirect=true

     else 
        @year=nil

     end

     if redirect
               redirect_to users_path(:category =>@category, :semester => @semester,:year =>@year,:search => params[:search])
     end
    
    #filter
     if @category && @semester && @year
              @events = Event.where(:category =>@category, :semester => @semester,:year =>@year).paginate(:page => params[:page],per_page:20) 

     elsif  @category && @semester
              @events = Event.where(:category =>@category, :semester => @semester).paginate(:page => params[:page],per_page:20)
              
     elsif  @category && @year
              @events = Event.where(:category =>@category,:year =>@year).paginate(:page => params[:page],per_page:20)
              
     elsif @semester && @year
              @events = Event.where(:semester => @semester,:year =>@year).paginate(:page => params[:page],per_page:20)     
          
     elsif @category
              @events = Event.where(:category =>@category).paginate(:page => params[:page],per_page:20)
              
     elsif @semester
              @events = Event.where(:semester => @semester).paginate(:page => params[:page],per_page:20)

     elsif @year
              @events = Event.where(:year =>@year).paginate(:page => params[:page],per_page:20)
                
     else
              @events= Event.paginate(:page => params[:page],per_page:20)

     end

   else
    
      @events = Event.paginate(:page => params[:page],per_page:20)
      session[:category]=nil
      session[:semester]=nil
      session[:year]=nil

   end

  end

  # GET /events/1
  # GET /events/1.json
  def show
  @eventusers = @event.users.paginate(:page => params[:page],per_page:5)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def checkin
      @user = User.find_by(uin: params[:user][:uin])
      @event = Event.find_by(id: params[:id])
  if @user != nil
        # Log the user in and redirect to the user's show page.
    if @event.users !=nil
      @event.users.each do |user|
         if (user == @user)
           redirect_to event_path
           flash[:notice] = "This UIN Has Already Checked in"
           return
         end
      end
    end
      @event.users<<@user
      redirect_to event_path(@event)
  else
      # Create an error message.
      redirect_to event_path(@event)
      flash[:notice] = "Invalid UIN"
  end
  end

  

  private
  
    def has_access?
      if (session[:admin_id] == nil)
      flash[:notice] ="You shoud have admin access to view this information"
      redirect_to root_url
      return
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :year, :semester, :category, :description)
    end
end
