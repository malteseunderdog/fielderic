class FieldsController < ApplicationController
  
  def index
    @fields = Field.get_by_player(1) # FIXME: currently hardcoded
   
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @fields }
    end
  end

  def organise
    # get the field record with this player as the organiser
    @fields = Field.get_organised_by_player(1) # FIXME: currently hardcoded
    
    @players_per_match = Hash.new
    # for each one of the organised matches -- get all other players and
    # put them in a map
    @fields.each do |field|
      @players_per_match[field.id] = Field.get_by_match(field.match_id)
    end

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @fields }
    end
  end
  
end
