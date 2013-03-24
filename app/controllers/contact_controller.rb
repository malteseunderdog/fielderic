class ContactController < ApplicationController
  
  skip_before_filter :require_login

  def sent
    UserMailer.contact_us(params[:name], params[:email], params[:message]).deliver
  end
  
end