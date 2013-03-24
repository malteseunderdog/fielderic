require 'mail'

class PlayersController < ApplicationController

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
  
  def is_email_valid(email)
    begin
      mail_address = Mail::Address.new(email)
      is_valid = mail_address.domain && mail_address.address == email
      mail_address_tree = mail_address.__send__(:tree)
      is_valid &&= (mail_address_tree.domain.dot_atom_text.elements.size > 1)
    rescue Exception => e   
      is_valid = false
    end
    is_valid
  end
  
  def is_mobile_valid(mobile)
    is_valid = false
    if ((mobile =~ (/^\+?[ ()0-9]+$/)) == 0)
      is_valid = true
    end
    is_valid
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

    if (@player.nickname.nil? || (@player.nickname =~ (/^\s*$/)) == 0)
      @player.errors.add("nickname", "Nickname cannot be empty")
    end
    if (@player.name.nil? || (@player.name =~ (/^\s*$/)) == 0)
      @player.errors.add("full name", "Full Name cannot be empty")
    end
    if (@player.email.nil? || (@player.email =~ (/^\s*$/)) == 0)
      @player.errors.add("email", "Email address cannot be empty")
    elsif (!is_email_valid(@player.email))
      @player.errors.add("email", "Email address is not valid")
    end
    if (@player.mobile.nil? || (@player.mobile =~ (/^\s*$/)) == 0)
      @player.errors.add("mobile", "Mobile number cannot be empty")
    elsif (!is_mobile_valid(@player.mobile))
      @player.errors.add("mobile", "Mobile number is not valid")
    end
    if (!player_by_nickname.nil?)
      @player.errors.add("nickname", "Someone already has that nickname")
    end
    if (!player_by_email.nil?)
      @player.errors.add("email", "Someone already has that email address")
    end
    if (!player_by_mobile.nil?)
      @player.errors.add("mobile", "Someone already has that mobile number")
    end

    if (!@player.errors.empty?)
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
          flash[:player_updated] = "Your profile has been created. Go to your edit profile page to set your password."
          format.html { redirect_to('/players') }
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
          @player.errors.add("old_password", "Incorrect password")
        elsif value.length < 6
          @player.errors.add("new_password", "Password should be 6 characters or longer")
        elsif !value.eql?params[:confirm_password]
          @player.errors.add("new_password", "Passwords do not match")
        elsif params[:confirm_password].empty? || params[:confirm_password].nil?
          @player.errors.add("new_password", "Password cannot be empty")
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
          flash[:player_updated] = "Password was set successfully."
          format.html { redirect_to('/players') }
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
      
      if (@player_params_name.nil? || (@player_params_name =~ (/^\s*$/)) == 0)
        @player.errors.add("name", "Full Name cannot be empty")
      end
      if (@player_params_email.nil? || (@player_params_email =~ (/^\s*$/)) == 0)
        @player.errors.add("email", "Email address cannot be empty")
      elsif (!is_email_valid(@player_params_email))
        @player.errors.add("email", "Email address is not valid")
      end
      if (@player_params_mobile.nil? || (@player_params_mobile =~ (/^\s*$/)) == 0)
        @player.errors.add("mobile", "Mobile number cannot be empty")
      elsif (!is_mobile_valid(@player_params_mobile))
        @player.errors.add("mobile", "Mobile number is not valid")
      end
      if (!@player_by_email.nil?)
        @player.errors.add("email", "Someone already has that email address")
      end
      if (!@player_by_mobile.nil?)
        @player.errors.add("mobile", "Someone already has that mobile number")
      end
        
      if (!@player.errors.empty?)
        @player.name = @player_params_name
        @player.email = @player_params_email
        @player.mobile = @player_params_mobile
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @player, :status => :unprocessable_entity }
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
            format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
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
