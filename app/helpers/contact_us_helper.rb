module ContactUsHelper
  def check_message_validity(message)
    if (message.nil? || (message =~ (/^\s*$/)) == 0)
      message_error = "Message cannot be empty"
    end
    message_error
  end
end
