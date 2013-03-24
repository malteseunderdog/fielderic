class ContactController < ApplicationController

  include ApplicationHelper  
  include ContactUsHelper
  skip_before_filter :require_login

  def sent
    @contact_name = params[:name].strip
    @contact_email = params[:email].downcase.strip
    @contact_message = params[:message]
    
    @contact_name_error = check_name_validity(@contact_name)
    @contact_email_error = check_email_validity(@contact_email)
    @contact_message_error = check_message_validity(@contact_message)
    
    if (!@contact_name_error.nil? || !@contact_email_error.nil? || !@contact_message_error.nil?)
      respond_to do |format|
        format.html { render :template => "/contact/show" }
        format.xml  { render :xml => [@contact_name_error, @contact_email_error, @contact_message_error], :status => :unprocessable_entity }
      end
    else
      UserMailer.contact_us(@contact_name, @contact_email, @contact_message).deliver
    end
  end
  
end