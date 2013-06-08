class JudgeController < ApplicationController
  def ranking
    @id = prams[:id]
  end
  def tasks
    @id = params[:id]
  end
  def task
    @id = params[:id]
    @serial = params[:serial]
  end
  def submit
    @id = params[:id]
  end
  def submittion
    @id = params[:id]
  end
  def detail
    @id = params[:id]
    @result_id = params[:result_id]
=begin
    @result = Result
      .select("Results.id,state_id,Results.contest_id,serial,contest_task_id,task_id,score,Tasks.name as task_name,lang_id,user_id,Users.name as user_name,Results.created_at,state_name,message")
      .joins(:state)
      .joins(:contest_task => :task)
      .joins(:user)
      .find(@result_id)

    @details = Detail
      .select("result_id,state_id,output,input,state_name,time,memory")
      .where(:result_id=>@result_id).joins(:state)
    @code = File.open("task_data/contests/#{@result.contest_id}/#{@result.id}_#{@result.user_id}_#{@result.contest_task_id}/Main."+(@result.lang_id==1?"c":"cpp")).read
=end
  end
end
