class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:create]
  #before_save :add_children, :only => [:create]
  helper_method :sort_column, :sort_direction
  
  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)
    @match.hashkey = make_id(@match.to_json.to_str) if params[:hashkey].nil?
    @match.date = Date.strptime(@match.date, "%a %d %b %Y") if @match.date.is_a? String
    @match.mom = Player.where(:name => params[:mom]).first.id if params[:mom].is_a? String
    #binding.pry
 
    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render action: 'show', status: :created, location: @match }
      else
        format.html { render action: 'new' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
    
    #params[:innings].each do |inn|
      #debugger
      #binding.pry
    
      #i = @match.innings.create(inn)
      #debugger
    #end

  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    @match.date = Date.strptime(@match.date, "%a %d %b %Y") if @match.date.is_a? String
    respond_to do |format|
      if @match.update(match_params)
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:matchname, :date, :innings, :mom, :hashkey)
    end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Match.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
