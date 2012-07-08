class MatchesController < ApplicationController
  before_filter :require_login
  # just apply above on join method -- for now (bit of an overkill)
  skip_before_filter :require_login, :except => [ :join ]
  
  # GET /match
  # GET /match.xml
  def index
    @matches = Match.future

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @match }
    end
  end
  
  def mymatches
    if (current_facebook_user != nil)
      player_id = current_facebook_user.id
    elsif (!session[:logged_in_player].nil?)
      player_id = session[:logged_in_player].id
    end  
    
    @matches = Match.my_future_matches(player_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /match/1
  # GET /match/1.xml
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /match/new
  # GET /match/new.xml
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /match/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /match
  # POST /match.xml
  def create
    @match = Match.new(params[:match])

    respond_to do |format|
      if @match.save
        flash[:notice] = 'Match was successfully created.'
        format.html { redirect_to(@match) }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /match/1
  # PUT /match/1.xml
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        flash[:notice] = 'Match was successfully updated.'
        format.html { redirect_to(@match) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /match/1
  # DELETE /match/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(match_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /match/1/join
  def join
            
    # mark the user as joining a particular match
    @match = Match.find(params[:id])
    @match.required = @match.required - 1
    
    # the following should be done in a transactional manner ...
    # otherwise all sorts of race conditions could come back to bite us
    
    # add a field entry for this logged in user
    @field = @match.fields.create(:joined => DateTime.now, 
                                  :player_id => 1, # FIXME: this should be taken from session?
                                  :organiser => false)
    
    
    # this will worry about validations
    if @match.save 
      flash[:notice] = "Match just joined: " + @match.variety + " match, " + @match.kickoff.to_s + " at " + @match.location
    else
      flash[:notice] = "No more places to join"
    end

    # now send back to index, but first we must initialise any attributes
    # which need to be rendered  
    @matches = Match.future
    # render the main index page
    render "index"
        
  end 
  
  
  private # after this all methods are private -- I think
    
    def require_login
      unless logged_in?
        flash[:notice] = "Not signed in"
        #render :action => action_name
      end
    end

    def logged_in?
      !session[:player].nil?
    end
      
end
