class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery

  before_filter :ensure_authenticated
  def ensure_authenticated
    if !current_facebook_user.nil?
      player = Player.get_player_with_facebook_id(current_facebook_user.id)
      current_facebook_user.fetch
      if player == nil
        Player.new_facebook_player(current_facebook_user)
      end
    end
  end

  def current_facebook_user
    begin
      if (Facebooker2.oauth2)
        oauth2_fetch_client_and_user
      else
        fetch_client_and_user
      end
      @_current_facebook_user
    rescue Exception=>e
    # Catch exceptions if user logs out from Facebook from another application
    # while logged in on FE using Facebook.
    # User is simply signed out of FE - no need to do any handling here.
    end
  end
  
  
  def fb_connect_async_js(app_id=Facebooker2.app_id,options={},&proc)
    puts "il madonna putz man! u ta hdejja!"
    opts = Hash.new.merge!(options)
    cookie = opts[:cookie].nil? ? true : opts[:cookie]
    status = opts[:status].nil? ? true : opts[:status]
    xfbml = opts[:xfbml].nil?   ? true : opts[:xfbml]
    channel_url = opts[:channel_url]
    lang = opts[:locale] || 'en_US'
    extra_js = capture(&proc) if block_given?
    js = <<-JAVASCRIPT
    <div id="fb-root"></div>
    <script>
      window.fbAsyncInit = function() {
        FB.init({
          appId  : '#{app_id}',
          status : #{status}, // check login status
          cookie : #{cookie}, // enable cookies to allow the server to access the session
          #{"channelUrl : '#{channel_url}', // add channelURL to avoid IE redirect problems" unless channel_url.blank?}
          oauth : true,
          xfbml  : #{xfbml}  // parse XFBML
        });
        #{extra_js}
        
        FB.getLoginStatus(function(response){
          alert(response.authResponse.userID);
          FB.api('/me', function(responseForName) {
            alert('Your name is ' + responseForName.username);
            $("#fb_username").html(responseForName.username);
          });
        });
        
      };

      (function() {
        var e = document.createElement('script'); e.async = true;
        e.src = document.location.protocol + '//connect.facebook.net/#{lang}/all.js';
        document.getElementById('fb-root').appendChild(e);
      }());
    </script>
    JAVASCRIPT
    escaped_js = fb_html_safe(js)
    if block_given? 
     concat(escaped_js)
     #return the empty string, since concat returns the buffer and we don't want double output
     # from klochner
     "" 
    else
     escaped_js
    end
  end
  
  

  def current_player
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end
end
