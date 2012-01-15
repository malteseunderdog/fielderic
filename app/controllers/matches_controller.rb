class MatchesController < ApplicationController
  # GET /match
  # GET /match.xml
  def index
    @match = Match.future

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
    # this will worry about validations
    if @match.save
      flash[:notice] = "Match joined"
    else
      flash[:notice] = "No more places to join"
    end
    redirect_to(matches_url)
  end 
  
end
