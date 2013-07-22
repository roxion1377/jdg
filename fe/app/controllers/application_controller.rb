class ApplicationController < ActionController::Base
  protect_from_forgery
  def check_ver
    if session[:user_id]
      if session[:ver] != Settings.version
        reset_session
      end
    end
  end 
  before_filter :check_ver
  def block_non_user
    if session[:user_id].blank?
      redirect_to '/login'
      false
    else
      true
    end
  end
  def block_time(contest_id)
    contest = Contest.find(contest_id)
    t = Time.now
    p t,contest.begin,contest.end
#    if ( t>=contest.begin && t<=contest.end ) || session[:admin]
    if ( t>=contest.begin ) || session[:admin]
      true
    else
      render :text => "jikan gai"
      false
    end
  end
  def contest_not_begin(contest_id)
    contest = Contest.find(contest_id)
    t = Time.now
    return true if t < contest.begin
    false
  end
  def contest_end(contest_id)
    contest = Contest.find(contest_id)
    t = Time.now
	puts "hoaaaaaaaaaaa #{t}"
    return t > contest.end ? true : false
  end

end
