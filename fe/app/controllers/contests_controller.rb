require 'thread'
require 'drb/drb'
class ContestsController < ApplicationController
  # GET /contests/1/ranking.json
  def ranking
        @cont = Contest.find(params[:id])
	@results = Result.select("contest_id,user_id").where(:contest_id=>params[:id]).where(["created_at >= ? AND created_at <= ?",@cont.begin,@cont.end]).uniq(:user_id)
	us = Struct.new("Us",:user_id,:user_name,:score,:scores,:state,:wa,:wrong_num,:last)
	u = []
	used = {}
	@results.each { |a|
		u << us.new(a.user_id,User.select("id,name").find(a.user_id).name,0,{},{},{},Result.select("contest_id,state_id").where(["contest_id=? and state_id>=4 and state_id<=7 and user_id=?",params[:id],a.user_id]).where(["created_at >= ? AND created_at <= ?",@cont.begin,@cont.end]).count,Result.select("contest_id,created_at").where(:user_id=>a.user_id).where(["created_at >= ? AND created_at <= ?",@cont.begin,@cont.end]).maximum(:created_at))
	}
	@cts = ContestTask.where(:contest_id=>params[:id]).order(:serial)
	@cts.each { |a|
		u.each { |v|
			r = Result.where(:user_id=>v.user_id,:contest_task_id=>a.id,:contest_id=>params[:id]).uniq(:user_id).order(:score).where(["created_at >= ? AND created_at <= ?",@cont.begin,@cont.end]).reverse_order.first
			ms = r ? r.score : 0
			v.score += ms
			v.scores[a.serial] = ms
			v.state[a.serial] = r ? (r.state_id == 8 ? 1 : 2) : 0
			v.wa[a.serial] = r ? Result.select("contest_id,state_id").where(["contest_id=? and state_id>=4 and state_id<=7 and user_id=? and contest_task_id=?",params[:id],v.user_id,a.id]).count : 0
		}
	}
	
	u.sort!{|a,b|
		if a.score != b.score
			b.score <=> a.score
		elsif a.wrong_num != b.wrong_num
			a.wrong_num <=> b.wrong_num
		else
			a.last <=> b.last
		end
	}
	respond_to do |format|
		format.json { render json: u }
		format.xml {
			re = []
			u.each {|k|
				r = {}
				r['user_id'] = k.user_id
				r['user_name'] = k.user_name
				r['score'] = k.score
				r['scores'] = k.scores
				r['state'] = k.state
				r['wa'] = k.wa
				r['wrong_num'] = k.wrong_num
				r['last'] = k.last
				re << r
			}
			render xml: re
		}
	end
  end

  def score
    ct = ContestTask.where(:contest_id=>params[:id])
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
    if !session[:admin] && (!block_non_user || !block_time(params[:id]))
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
	#q = DRbObject.new_with_uri("druby://localhost:12345")
	#q.push(res.id)
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
