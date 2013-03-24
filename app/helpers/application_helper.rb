module ApplicationHelper
  def check_name_validity(name)
    if (name.nil? || (name =~ (/^\s*$/)) == 0)
      name_error = "Name cannot be empty"
    end
    name_error
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
  
  def check_email_validity(email)
    if (email.nil? || (email =~ (/^\s*$/)) == 0)
      email_error = "Email address cannot be empty"
    elsif (!is_email_valid(email))
      email_error = "Email address is not valid"
    end
    email_error
  end
end
