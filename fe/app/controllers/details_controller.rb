class DetailsController < ApplicationController
  # GET /details
  # GET /details.json
  def index
    @details = Detail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @details }
    end
  end

  # GET /details/1
  # GET /details/1.json
  def show
    @result_id = params[:id]
#    contest_id = Result.find(@result_id).contest_id
    @result = Result
      .select("Results.id,state_id,Results.contest_id,serial,contest_task_id,task_id,score,Tasks.name as task_name,lang_id,user_id,Users.name as user_name,Results.created_at,state_name,message")
      .joins(:state)
      .joins(:contest_task => :task)
      .joins(:user)
      .find(@result_id)
#contest_not_end ? .where(:user_id=>session[:user_id]) : .all
    if !contest_end(@result.contest_id) && @result.user_id!=session[:user_id] && !session[:admin]
      render json: {}
      return
    end
    @details = Detail
      .select("result_id,state_id,output,input,state_name,time,memory")
      .where(:result_id=>@result_id).joins(:state)
    @code = ""
    @code = File.open("task_data/contests/#{@result.contest_id}/#{@result.id}_#{@result.user_id}_#{@result.contest_task_id}/Main."+(@result.lang_id==1 ? "c":"cpp")).read

#    @detail = Detail.find(params[:id])

    respond_to do |format|
#      format.html # show.html.erb
      format.json { render json: {:result=>@result,:code=>@code,:details=>@details} }
    end
  end

  # GET /details/new
  # GET /details/new.json
  def new
    @detail = Detail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @detail }
    end
  end

  # GET /details/1/edit
  def edit
    @detail = Detail.find(params[:id])
  end

  # POST /details
  # POST /details.json
  def create
    @detail = Detail.new(params[:detail])

    respond_to do |format|
      if @detail.save
        format.html { redirect_to @detail, notice: 'Detail was successfully created.' }
        format.json { render json: @detail, status: :created, location: @detail }
      else
        format.html { render action: "new" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /details/1
  # PUT /details/1.json
  def update
    @detail = Detail.find(params[:id])

    respond_to do |format|
      if @detail.update_attributes(params[:detail])
        format.html { redirect_to @detail, notice: 'Detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /details/1
  # DELETE /details/1.json
  def destroy
    @detail = Detail.find(params[:id])
    @detail.destroy

    respond_to do |format|
      format.html { redirect_to details_url }
      format.json { head :no_content }
    end
  end
end
