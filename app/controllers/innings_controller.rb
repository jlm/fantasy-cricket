class InningsController < ApplicationController
  before_action :set_innings, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:create]

  # GET /innings
  # GET /innings.json
  def index
    @match = Match.find(params[:match_id])
    @innings = @match.innings
  end

  # GET /innings/1
  # GET /innings/1.json
  def show
    @match = Match.find(params[:match_id])
    @innings = @match.innings.find(params[:id])
    @player_scores = @innings.player_scores.paginate(page: params[:page], per_page: 5)
  end

  # GET /innings/new
  def new
#    binding.pry
    @match = Match.find(params[:match_id])
    @innings = @match.innings.build
  end

  # GET /innings/1/edit
  def edit
    @match = Match.find(params[:match_id])
  end

  # POST /innings
  # POST /innings.json
  def create
    @match = Match.find(params[:match_id])
    @innings = @match.innings.build(innings_params)
    #@innings = Innings.new(innings_params)
    @innings.numbats = params[:bat].nil? ? 0 : params[:bat].count
    @innings.numbowls = params[:bowl].nil? ? 0 : params[:bowl].count
    @innings.numfields = params[:field].nil? ? 0 : params[:field].count
    # Here, we need to create the hashkey if there isn't one.  Submitted JSON 
    # POSTS will include it, but the "new" form doesn't.
    @innings.hashkey = make_id(@innings.to_json.to_str) if params[:hashkey].nil?
    @innings.matchname = @match.matchname if params[:matchname].nil?
    @innings.date = @match.date if params[:date].nil?
    @innings.date = Date.strptime(@innings.date, "%a %d %b %Y") if @innings.date.is_a? String
    #binding.pry
    # The incremental player update method will be invoked by before_save or similar.
    #binding.pry

    respond_to do |format|
      if @innings.save
        format.html { redirect_to match_innings_url(@match, @innings), notice: 'Innings was successfully created.' }
        format.json { render action: 'show', status: :created, location: match_innings_path(@match, @innings) }
        #format.json { render action: 'show', status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @innings.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /innings/1
  # PATCH/PUT /innings/1.json
  def update
    @match = Match.find(params[:match_id])
    @innings.date = @match.date if params[:date].nil?
    @innings.date = Date.strptime(@innings.date, "%a %d %b %Y") if @innings.date.is_a? String
    respond_to do |format|
      if @innings.update(innings_params)
        format.html { redirect_to match_innings_index_url, notice: 'Innings was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @innings.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /innings/1
  # DELETE /innings/1.json
  def destroy
    @innings.destroy
    respond_to do |format|
      #binding.pry
      format.html { redirect_to match_innings_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_innings
      @innings = Innings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def innings_params
      params.require(:innings).permit(:matchname, :date, :inningsname, :innings_id, :match_id, :bat, :bowl, :field, :hashkey)
    end
end
