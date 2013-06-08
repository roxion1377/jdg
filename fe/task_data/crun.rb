#! ruby -Ku

require 'rubygems'
require 'cgi'
require 'active_record'
require 'scanf'

ActiveRecord::Base.establish_connection(
  :adapter=> 'sqlite3',
  :database=> '../db/development.sqlite3',
  :pool => 5,
  :timeout=> 5000
)
class Result < ActiveRecord::Base
end
class Detail < ActiveRecord::Base
end
class Task < ActiveRecord::Base
end
class ContestTask < ActiveRecord::Base
end


detailid = ARGV[0]
detail = Detail.find(detailid).select("id,result_id,state,time,memory,input,output")
detail.state = 0
detail.save
result = Result.find(detail.result_id)
task_id = ContestTask.find(result.contest_task_id)
task = Task.find(task_id)
dir = "contests/#{result.contest_id}/#{result.id}_#{result.user_id}_#{result.contest_task_id}"

p task.tle

`./cpu #{dir}/a.out #{task.tle} #{task.mle*1024} #{dir}/result.txt < #{detail.input} > #{dir}/output.txt`

open("#{dir}/result.txt") { |f|
	case f.gets.chomp
	when 'Error'
		case f.gets.chomp
		when 'MLE'
			detail.state = 1
			detail.save
			ac = false
		when 'TLE'
			detail.state = 2
			detail.save
			ac = false
		end
	when 'Safe'
		code = f.gets.scanf("Exit code: %d")[0]
		mem = f.gets.scanf("%s %d")[1]
		time = (f.gets.scanf("%s %f")[1]*1000).to_i
		if code != 0
			detail.state = 3
			detail.save
			ac = false
		elsif mem > task.mle*1024
			detail.state = 1
			detail.save
			ac = false
		elsif time > task.tle*1000
			detail.state = 2
			detail.save
			ac = false
		else
			$res = 1
			case task.judge
			when 1
				$res = system("diff #{detail.output} #{dir}/output.txt > /dev/null")
			when 2
				$res = system("./errorj #{detail.output} #{dir}/output.txt > /dev/null")
			when 2
				#$res = system("./tasks/#{task.id}/validator #{detail.output} #{dir}/output.txt > /dev/null")
			end
			if !$res
				detail.state = 4
				detail.time = time
				detail.memory = mem
				detail.save
				ac = false
			else
				detail.state = 5
				detail.time = time
				detail.memory = mem
				detail.save
			end
		end
	end
}
#system("rm #{dir}/result.txt")
