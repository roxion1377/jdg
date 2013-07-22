class ContestTasksController < ApplicationController
  # GET /contest_tasks
  # GET /contest_tasks.json
  def index
    @contest_tasks = ContestTask
      .select("Contest_tasks.id,contest_id,task_id,serial,name,tle,mle")
      .where(contest_id:params[:contest_id])
      .joins(:task)
      .order("serial")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contest_tasks }
      format.xml  { render xml:  @contest_tasks }
    end
  end

  # GET /contest_tasks/1
  # GET /contest_tasks/1.json
  def show
    @contest_task = ContestTask.find(params[:id])
#    @task = ContestTask.find(params[:id])
#      .select("contest_id,task_id,serial,body,judge_type,mle,name,tle")
#      .where(contest_id:params[:id],serial:params[:serial])
#      .joins(:task).first

#    render :action => "../tasks/show"
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contest_task }
    end
  end

  def task
    if (contest_not_begin params[:id]) && !session[:admin]
      render :json => []
      return
    end
    @task = ContestTask.select("contest_id,task_id,serial,body,judge_type,mle,name,tle")
      .where(contest_id:params[:id],serial:params[:serial])
      .joins(:task).first
    render :json => @task
  end

  def score
    ct = ContestTask.where(params[:id])
    ret = {}
    ct.each{|c|
      t = Task.find(c.task_id)
      i = Input.where(:task_id=>t).sum(:score)
      ret[c.serial] = i
    }
    respond_to do |format|
      format.json { render json: ret }
      format.xml  { render xml: ret }
    end
  end

  # GET /contest_tasks/new
  # GET /contest_tasks/new.json
  def new
    @contest_task = ContestTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contest_task }
    end
  end

  # GET /contest_tasks/1/edit
  def edit
    @contest_task = ContestTask.find(params[:id])
  end

  # POST /contest_tasks
  # POST /contest_tasks.json
  def create
    @contest_task = ContestTask.new(params[:contest_task])
    @contest_task.key = @contest_task.contest_id.to_s+"_"+@contest_task.serial.to_s

    respond_to do |format|
      if @contest_task.save
        format.html { redirect_to @contest_task, notice: 'Contest task was successfully created.' }
        format.json { render json: @contest_task, status: :created, location: @contest_task }
      else
        format.html { render action: "new" }
        format.json { render json: @contest_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contest_tasks/1
  # PUT /contest_tasks/1.json
  def update
    @contest_task = ContestTask.find(params[:id])

    respond_to do |format|
      if @contest_task.update_attributes(params[:contest_task])
        format.html { redirect_to @contest_task, notice: 'Contest task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contest_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contest_tasks/1
  # DELETE /contest_tasks/1.json
  def destroy
    @contest_task = ContestTask.find(params[:id])
    @contest_task.destroy

    respond_to do |format|
      format.html { redirect_to contest_tasks_url }
      format.json { head :no_content }
    end
  end
end
