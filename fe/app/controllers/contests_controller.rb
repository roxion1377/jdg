class ContestsController < ApplicationController
  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contests }
    end
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @contest = Contest.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contest }
    end
  end

  def tasks
    @contest = Contest.find(params[:id])
  end

  # GET /contests/new
  # GET /contests/new.json
  def new
    block_non_user
    @contest = Contest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/1/edit
  def edit
    block_non_user
    @contest = Contest.find(params[:id])
    @tasks = Task.all
  end

  # POST /contests
  # POST /contests.json
  def create
    block_non_user
    @contest = Contest.new(params[:contest])

    respond_to do |format|
      if @contest.save
        format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render json: @contest, status: :created, location: @contest }
        Dir::mkdir("task_data/contests/#{@contest.id}")
      else
        format.html { render action: "new" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contests/1
  # PUT /contests/1.json
  def update
    block_non_user
    @contest = Contest.find(params[:id])

    respond_to do |format|
      if @contest.update_attributes(params[:contest])
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit
    if !block_non_user || !block_time(params[:id])
    else
      if request.post? && params[:task] && params[:lang] && params[:code]
        contest_id = params[:id]
        res = Result.create(:user_id=>session[:user_id],:contest_task_id=>params[:task],:lang_id=>params[:lang],:state_id=>9,:contest_id=>contest_id,:score=>0)
        dir = "#{res.id}_#{res.user_id}_#{res.contest_task_id}"
        Dir::mkdir("task_data/contests/#{contest_id}/#{dir}")
        ext = ( params[:lang].to_s=="1" ? "c" : "cpp" )
        File.open("task_data/contests/#{contest_id}/#{dir}/Main."+ext,'w'){|f|
          f.write(params[:code])
        }
        `ruby judge.rb #{res.id} > /dev/null &`
        redirect_to "/judge/#{contest_id}/submittion"
      else
        render :text => "err"
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    block_non_user
    @contest = Contest.find(params[:id])
    @contest.destroy

    respond_to do |format|
      format.html { redirect_to contests_url }
      format.json { head :no_content }
    end
  end
end
