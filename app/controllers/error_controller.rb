class ErrorController < ApplicationController

  def handle404
    flash[:error_404] = "404 error. That's for making URLs up!"
    render "index"
  end

end