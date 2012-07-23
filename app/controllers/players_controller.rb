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

  def password
    @player = Player.find(params[:id])
  end

  # POST /player
  # POST /player.xml
  def create
    @player = Player.new(params[:player])

    # Get player coordinates and location
    #@client_ip = request.remote_ip
    #@player_locator = PlayerLocator.new
    #@player.coordinates = @player_locator.get_coordinates(@client_ip)
    #@player.location = @player_locator.get_location(@client_ip)

    # Check if nickname, email and mobile number are unique
    player_by_nickname = Player.get_player_by_nickname(@player.nickname)
    player_by_email = Player.get_player(@player.email)
    player_by_mobile = Player.get_player_by_mobile(@player.mobile)

    if (!player_by_nickname.nil? || !player_by_email.nil? || !player_by_mobile.nil?)
      if (!player_by_nickname.nil?)
        @player.errors.add("nickname", "Someone already has that nickname")
      end
      if (!player_by_email.nil?)
        @player.errors.add("email", "Someone already has that email address")
      end
      if (!player_by_mobile.nil?)
        @player.errors.add("mobile", "Someone already has that mobile number")
      end
      respond_to do |format|
        format.html { render :template => "home/index" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    else
    # Set registration time
      @player.registration = Time.now

      respond_to do |format|
        if @player.save
          session[:logged_in_player] = @player
          new_cookie_flag = (params[:remember_me] == "1")
          flash[:notice] = 'Your profile has been created. Go to your edit profile page to set your location and password.'
          format.html { redirect_to(@player) }
          format.xml  { render :xml => @player, :status => :created, :location => @player }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /player/1
  # PUT /player/1.xml
  def update
    @player = Player.find(params[:id])

    player_params = params[:player].stringify_keys
    player_params.each do |key,value|
      if key.eql? "email"
      @player_params_email = value
      elsif key.eql? "mobile"
      @player_params_mobile = value
      elsif key.eql? "password"
        if ((!params[:old_password].nil?) && (!Digest::SHA2.hexdigest(@player.id.to_s() + params[:old_password]).eql?@player.password))
          @player.errors.add("old_password", "Incorrect password")
        end
        if !value.eql?params[:confirm_password]
          @player.errors.add("confirm_password", "Passwords do not match")
        end
        h = params[:player]
        clear_password = h["password"]
        h["password"] = Digest::SHA2.hexdigest(@player.id.to_s() + clear_password)
      end
    end

    if session[:updating_password]
      session[:updating_password] = nil
      respond_to do |format|
        if ((!@player.errors.any?) && (@player.update_attributes(params[:player])))
          flash[:notice] = 'Password was set successfully'
          format.html { redirect_to(@player) }
          format.xml  { head :ok }
        else
          format.html { render :action => "password" }
          format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
        end
      end
    else
      if (!@player.email.eql? @player_params_email)
        @player_by_email = Player.get_player(@player_params_email)
      end
      if (!@player.mobile.eql? @player_params_mobile)
        @player_by_mobile = Player.get_player_by_mobile(@player_params_mobile)
      end
        
      if (!@player_by_email.nil?) || (!@player_by_mobile.nil?)
        if (!@player_by_email.nil?)
          @player.errors.add("email", "Someone already has that email address")
          @player.email = @player_params_email
        end
        if (!@player_by_mobile.nil?)
          @player.errors.add("mobile", "Someone already has that mobile number")
          @player.mobile = @player_params_mobile
        end
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @player, :status => :unprocessable_entity }
        end
      else
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
end
