module AuthenticatedSystem
  protected
    # Returns true or false if the player is logged in.
    # Preloads @current_player with the player model if they're logged in.
    def logged_in?
      !!current_player
    end

    # Accesses the current player from the session.
    # Future calls avoid the database because nil is not equal to false.
    def current_player
      @current_player ||= (login_from_session || login_from_basic_auth || login_from_cookie || login_from_fb) unless @current_player == false
    end

    # Store the given player id in the session.
    def current_player=(new_player)
      session[:player_id] = new_player ? new_player.id : nil
      @current_player = new_player || false
    end

    # Check if the player is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the player
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_player.login != "bob"
    #  end
    #
    def authorized?(action = action_name, resource = nil)
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the player is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to new_session_path
        end
        # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
        # Add any other API formats here.  (Some browsers, notably IE6, send Accept: */* and trigger
        # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
        # for a workaround.)
        format.any(:json, :xml) do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.  Set an appropriately modified
    #   after_filter :store_location, :only => [:index, :new, :show, :edit]
    # for any controller you want to be bounce-backable.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_player and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_player, :logged_in?, :authorized? if base.respond_to? :helper_method
    end

    #
    # Login
    #

    # Called from #current_player.  First attempt to login by the player id stored in the session.
    def login_from_session
      self.current_player = Player.find_by_id(session[:player_id]) if session[:player_id]
    end

    # Called from #current_player.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |login, password|
        self.current_player = Player.authenticate(login, password)
      end
    end

    #
    # Logout
    #

    # Called from #current_player.  Finaly, attempt to login by an expiring token in the cookie.
    # for the paranoid: we _should_ be storing player_token = hash(cookie_token, request IP)
    def login_from_cookie
      player = !cookies[:auth_token].blank? && Player.find_by_remember_token(cookies[:auth_token])
      if player && player.remember_token?
        self.current_player = player
        handle_remember_cookie! false # freshen cookie token (keeping date)
        self.current_player
      end
    end

    def login_from_fb
      if facebook_session
        self.current_player = Player.find_by_fb_user(facebook_session.user)
      end
    end

    # This is ususally what you want; resetting the session willy-nilly wreaks
    # havoc with forgery protection, and is only strictly necessary on login.
    # However, **all session state variables should be unset here**.
    def logout_keeping_session!
      # Kill server-side auth cookie
      @current_player.forget_me if @current_player.is_a? Player
      @current_player = false     # not logged in, and don't do it for me
      kill_remember_cookie!     # Kill client-side auth cookie
      session[:player_id] = nil   # keeps the session but kill our variable
      # explicitly kill any other session variables you set
    end

    # The session should only be reset at the tail end of a form POST --
    # otherwise the request forgery protection fails. It's only really necessary
    # when you cross quarantine (logged-out to logged-in).
    def logout_killing_session!
      logout_keeping_session!
      reset_session
    end

    #
    # Remember_me Tokens
    #
    # Cookies shouldn't be allowed to persist past their freshness date,
    # and they should be changed at each login

    # Cookies shouldn't be allowed to persist past their freshness date,
    # and they should be changed at each login

    def valid_remember_cookie?
      return nil unless @current_player
      (@current_player.remember_token?) &&
        (cookies[:auth_token] == @current_player.remember_token)
    end

    # Refresh the cookie auth token if it exists, create it otherwise
    def handle_remember_cookie!(new_cookie_flag)
      return unless @current_player
      case
      when valid_remember_cookie? then @current_player.refresh_token # keeping same expiry date
      when new_cookie_flag        then @current_player.remember_me
      else                             @current_player.forget_me
      end
      send_remember_cookie!
    end

    def kill_remember_cookie!
      cookies.delete :auth_token
    end

    def send_remember_cookie!
      cookies[:auth_token] = {
        :value   => @current_player.remember_token,
        :expires => @current_player.remember_token_expires_at }
    end

end
