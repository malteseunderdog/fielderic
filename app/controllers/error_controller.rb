class ErrorController < ApplicationController

  def handle404
    flash[:error_404] = "202 + 202 = 404"
    render "index"
  end

end