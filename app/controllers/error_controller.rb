class ErrorController < ApplicationController

  def handle404
    flash[:notice] = "404: Thank you Mario! But our princess is in another castle!"
    render "index"
  end

end