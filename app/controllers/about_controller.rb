class AboutController < ApplicationController
  
  skip_before_filter :require_login
  
end