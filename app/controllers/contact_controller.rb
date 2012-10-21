class ContactController < ApplicationController
  
  skip_before_filter :require_login
  
  def send_message
  end
  
end