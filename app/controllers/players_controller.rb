class PlayersController < ApplicationController

  include PlayersHelper
  skip_before_filter :require_login, :only => [ :create ]

  # GET /player
  # GET /player.xml
  def index
    begin
      @player = Player.find(session[:logged_in_player])
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
    @player = Player.find(session[:logged_in_player])
  end

  def password
    @player = Player.find(session[:logged_in_player])
  end
  
  # POST /player
  # POST /player.xml
  def create
    @player = Player.new(params[:player])
    @player.nickname = @player.nickname.strip
    @player.name = @player.name.strip
    @player.email = @player.email.downcase.strip
    @player.mobile = @player.mobile.strip
    
    # Get player coordinates and location
    #@client_ip = request.remote_ip
    #@player_locator = PlayerLocator.new
    #@player.coordinates = @player_locator.get_coordinates(@client_ip)
    #@player.location = @player_locator.get_location(@client_ip)

    # Check if nickname, email and mobile number are unique
    player_by_nickname = Player.get_player_by_nickname(@player.nickname)
    player_by_email = Player.get_player(@player.email)
    player_by_mobile = Player.get_player_by_mobile(@player.mobile)

    if (!player_by_nickname.nil?)
      @nickname_error = "Someone already has that nickname"
    end
    if (!player_by_email.nil?)
      @email_error = "Someone already has that email address"
    end
    if (!player_by_mobile.nil?)
      @mobile_error = "Someone already has that mobile number"
    end
    if (@nickname_error.nil?)
      @nickname_error = check_nickname_validity(@player.nickname)
    end
    @name_error = check_name_validity(@player.name)
    if (@email_error.nil?)
      @email_error = check_email_validity(@player.email)
    end
    if (@mobile_error.nil?)
      @mobile_error = check_mobile_validity(@player.mobile)
    end

    if (!@nickname_error.nil? || !@name_error.nil? || !@email_error.nil? || !@mobile_error.nil?)
      respond_to do |format|
        format.html { render :template => "home/index" }
        format.xml  { render :xml => [@nickname_error, @name_error, @email_error, @mobile_error], :status => :unprocessable_entity }
      end
    else
    # Set registration time
      @player.registration = Time.now
      respond_to do |format|
        if @player.save
          session[:logged_in_player] = @player
          new_cookie_flag = (params[:remember_me] == "1")
          flash[:player_updated] = "Your profile has been created. You now have the option to set your password."
          format.html { redirect_to('/players') }
          format.xml  { render :xml => @player, :status => :created, :location => @player }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => [@nickname_error, @name_error, @email_error, @mobile_error], :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /player/1
  # PUT /player/1.xml
  def update
    @player = Player.find(session[:logged_in_player])

    player_params = params[:player].stringify_keys
    player_params.each do |key,value|
      if key.eql? "email"
        params[:player]["email"] = value.downcase
        @player_params_email = value.downcase.strip
      elsif key.eql? "mobile"
        params[:player]["mobile"] = value
        @player_params_mobile = value.strip
      elsif key.eql? "name"
        params[:player]["name"] = value
        @player_params_name = value.strip
      elsif key.eql? "password"          
        if ((!params[:old_password].nil?) && (!Digest::SHA2.hexdigest(@player.id.to_s() + params[:old_password]).eql?@player.password))
          @old_password_error = "Incorrect password"
        elsif value.length < 6
          @new_password_error = "Password should be 6 characters or longer"
        elsif !value.eql?params[:confirm_password]
          @new_password_error = "Passwords do not match"
        end
        h = params[:player]
        clear_password = h["password"]
        h["password"] = Digest::SHA2.hexdigest(@player.id.to_s() + clear_password)
      end
    end

    if session[:updating_password]
      session[:updating_password] = nil
      respond_to do |format|
        if ((@old_password_error.nil?) && (@new_password_error.nil?) && (@player.update_attributes(params[:player])))
          flash[:player_updated] = "Password was set successfully."
          format.html { redirect_to('/players') }
          format.xml  { head :ok }
        else
          format.html { render :action => "password" }
          format.xml  { render :xml => [@old_password_error, @new_password_error], :status => :unprocessable_entity }
        end
      end
    else
      if (!@player.email.eql? @player_params_email)
        @player_by_email = Player.get_player(@player_params_email)
      end
      if (!@player.mobile.eql? @player_params_mobile)
        @player_by_mobile = Player.get_player_by_mobile(@player_params_mobile)
      end
      
      if (!@player_by_email.nil?)
        @email_error = "Someone already has that email address"
      end
      if (!@player_by_mobile.nil?)
        @mobile_error = "Someone already has that mobile number"
      end
      @name_error = check_name_validity(@player_params_name)
      if (@email_error.nil?)
        @email_error = check_email_validity(@player_params_email)
      end  
      if (@mobile_error.nil?)
        @mobile_error = check_mobile_validity(@player_params_mobile)
      end
        
      if (!@name_error.nil? || !@email_error.nil? || !@mobile_error.nil?)
        @player.name = @player_params_name
        @player.email = @player_params_email
        @player.mobile = @player_params_mobile
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => [@name_error, @email_error, @mobile_error], :status => :unprocessable_entity }
        end
      else
        params[:player][:name] = params[:player][:name].strip
        params[:player][:email] = params[:player][:email].strip
        params[:player][:mobile] = params[:player][:mobile].strip 
        respond_to do |format|
          if @player.update_attributes(params[:player])
            flash[:player_updated] = "Player was updated successfully."
            format.html { redirect_to('/players') }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => [@name_error, @email_error, @mobile_error], :status => :unprocessable_entity }
          end
        end
      end
    end
  end
  
  def remove_password
    @player = Player.find(params[:id])
    @player.password = nil
    respond_to do |format|
      if (@player.save!)
        flash[:player_updated] = "Password removed successfully."
        format.html { redirect_to('/players') }
        format.xml  { head :ok }
      else
        format.html { render :action => "password" }
        format.xml  { render :xml => [@old_password_error, @new_password_error], :status => :unprocessable_entity } 
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
  
  # finds all players who need notification and notifies them
  def self.notify_about_match()
    fields = Field.get_notifaction_fields()
    fields.each do |f|
      # record who we are sending messages to
      Rails.logger.info "Sending notification email to " + f.player.name
      # send the email
      UserMailer.notify_player_about_match(f.player, f.match).deliver
      # mark as notified
      f.notified = true
      # and save it so we will never pick up this guy again
      f.save!
    end 
  end
  
end
