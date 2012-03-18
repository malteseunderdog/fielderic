class PlayersController < ApplicationController
  # GET /player
  # GET /player.xml
  def index
    @player = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /player/1
  # GET /player/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /player/new
  # GET /player/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /player/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /player
  # POST /player.xml
  def create
    logout_keeping_session!
    @player = Player.new(params[:player])
    
    # Get player coordinates and location
    # @client_ip = request.remote_ip
    # @player_locator = PlayerLocator.new
    # @player.coordinates = @player_locator.get_coordinates(@client_ip)
    # @player.location = @player_locator.get_location(@client_ip)

    # Set registration time
    @player.registration = Time.now
    
    respond_to do |format|
      success = @player && @player.save
      if success && @player.errors.empty?
        # Protects against session fixation attacks, causes request forgery
        # protection if visitor resubmits an earlier form using back
        # button. Uncomment if you understand the tradeoffs.
        # reset session
        self.current_player = @player # !! now logged in
        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        format.html { redirect_to(@player) }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /player/1
  # PUT /player/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        flash[:notice] = 'Player was successfully updated.'
        format.html { redirect_to(@player) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /player/1
  # DELETE /player/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(player_url) }
      format.xml  { head :ok }
    end
  end
  
  def link_player_accounts
    if self.current_player.nil?
      #register with fb
      Player.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_player.link_fb_connect(facebook_session.user.id) unless self.current_player.fb_user_id == facebook_session.user.id
    end
    redirect_to '/'
  end
end
