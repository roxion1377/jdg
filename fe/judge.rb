#! ruby -Ku
# -*- coding: utf-8 -*-

require 'rubygems'
require 'cgi'
require 'active_record'
require 'scanf'
require 'benchmark'

USER = 'ubuntu'
SRV = '10.0.3.80'
PORT = 9999

print Benchmark.realtime {
  ActiveRecord::Base.establish_connection(
                                          :adapter=> 'sqlite3',
                                          :database=> './db/development.sqlite3',
                                          :pool => 5,
                                          :timeout=> 5000
                                          )
  class Result < ActiveRecord::Base
  end
  class Input < ActiveRecord::Base
  end
  class Detail < ActiveRecord::Base
  end
  class ContestTask < ActiveRecord::Base
  end
  class Task < ActiveRecord::Base
  end
  
  id = ARGV[0]
  cf = ARGV.length < 2 ? false : true
  result = Result.find(id)
  cid = result.contest_id
  work_dir = "contests/#{cid}/#{result.id}_#{result.user_id}_#{result.contest_task_id}/"
  Dir::chdir("task_data/")
  
  langs = ["C++","C","Java"]
  ext = ["cpp","c","java"]
  
  print Benchmark.realtime {
    `scp -P #{PORT} -c arcfour -r #{work_dir} #{USER}@#{SRV}:~/contests/#{cid}/`
  }," sec>copy work_dir to remote\n"
  print Benchmark.realtime {
    `ssh -p #{PORT} -c arcfour #{USER}@#{SRV} \"mkdir #{work_dir}/in\"`
  }," sec>mk in to remote\n"

  result.state_id = 1;
  result.save;  
  # コンパイル
  #if !cf
  print Benchmark.realtime {
    $f = false
    print Benchmark.realtime {
      case result.lang_id
      when 1
        $f = system("ssh -p #{PORT} -c arcfour #{USER}@#{SRV} \"ruby ccompile.rb #{work_dir} 2> /dev/null\"")
      when 2
        $f = system("ssh -p #{PORT} -c arcfour #{USER}@#{SRV} \"ruby cppcompile.rb #{work_dir} 2> /dev/null\"")
      else
        $f = false
      end
    }," sec>ssh compile\n"
    
    print Benchmark.realtime {
      `scp -P #{PORT} #{USER}@#{SRV}:~/#{work_dir}/cerror.txt #{work_dir}/cerror.txt`
    }," sec>get cerror.txt\n"
    result.message = CGI.escapeHTML(open(work_dir+"cerror.txt").read)
    
    if( !$f ) then
      result.state_id = 2
      result.save
      exit
    end
  }," sec>total compile time\n"
  
  result.state_id = 3
  result.save
  
  # ac
  state = 8
  score = 0

  task_id = ContestTask.find(result.contest_task_id).task_id
  input_dirs = Input.where(:task_id=>task_id).order(:name)
  details = []

  print Benchmark.realtime {
    input_dirs.each do |input_dir|
      `scp -P #{PORT} -r #{task_id}/#{input_dir.name} #{USER}@#{SRV}:~/#{work_dir}/in/#{input_dir.name}`
      inputs  = Dir::glob(task_id.to_s+"/"+input_dir.name+"/in/*").entries.sort 
      outputs  = Dir::glob(task_id.to_s+"/"+input_dir.name+"/out/*").entries.sort 
      inputs.length.times { |i|
        detail = Detail.create(:result_id=>result.id,:state_id=>3,:time=>0,:memory=>0,:input=>inputs[i],:output=>outputs[i])
        details << detail.id
      }
    end
  }," sec>register inputs\n"
  
  task = Task.find(task_id)
  
  
  print Benchmark.realtime {
    `ssh -p #{PORT} -c arcfour #{USER}@#{SRV} "ruby cpprun.rb #{work_dir} #{task.tle} #{task.mle}"`
  }," sec>run time\n"
  print Benchmark.realtime {
    `scp -P #{PORT} -c arcfour -r #{USER}@#{SRV}:~/#{work_dir}/results #{work_dir}/results`
  }," sec>copy results to local\n"
  print Benchmark.realtime {
    `scp -P #{PORT} -c arcfour -r #{USER}@#{SRV}:~/#{work_dir}/outputs #{work_dir}/outputs`
  }," sec>copy outputs to local\n"
  ac = true
  state = 8
  score = 0
  c = 0
  
  print Benchmark.realtime {
    input_dirs.each do |input_dir|
      print Benchmark.realtime {
        name = input_dir.name
        outputs  = Dir::glob("#{work_dir}/outputs/#{name}/*").entries.sort
        results  = Dir::glob("#{work_dir}/results/#{name}/*").entries.sort
        tac = true
        outputs.length.times { |i|
          open(results[i]) { |f|
            detail = Detail.find(details[c])
            c += 1
            case f.gets.chomp
            when 'Error'
              case f.gets.chomp
              when 'MLE'
                detail.state_id = 4
                detail.save
                tac = false
              when 'TLE'
                detail.state_id = 5
                detail.save
                tac = false
              end
            when 'Safe'
              code = f.gets.scanf("Exit code: %d")[0]
              mem = f.gets.scanf("%s %d")[1]
              time = (f.gets.scanf("%s %f")[1]*1000).to_i
              if code != 0
                detail.state_id = 6
                detail.save
                tac = false
              elsif mem > task.mle*1024
                detail.state_id = 4
                detail.save
                tac = false
              elsif time > task.tle*1000
                detail.state_id = 5
                detail.save
                tac = false
              else
                $res = 1
                case task.judge_type
                when 1
                  $res = system("diff #{detail.output} #{outputs[i]} > /dev/null")
                when 2
                  $res = system("./errorj #{detail.output} #{outputs[i]} > /dev/null")
                when 2
                  #$res = system("./tasks/#{task.id}/validator #{detail.output} #{outputs[i]} > /dev/null")
                end
                if !$res
                  detail.state_id = 7
                  detail.time = time
                  detail.memory = mem
                  detail.save
                  tac = false
                else
                  detail.state_id = 8
                  detail.time = time
                  detail.memory = mem
                  detail.save
                end
              end
            end
            state = [state,detail.state_id].min
          }
        }
        if tac
          score += input_dir.score
        else
          ac = false
        end
      }," sec>judge #{input_dir.name} time\n"
    end
  }," sec>total judge time\n"
  result.state_id = state
  result.score = score
  result.save
  `rm -r #{work_dir}/outputs #{work_dir}/results`
  `ssh -p #{PORT} -c arcfour #{USER}@#{SRV} "rm -r #{work_dir}"`
}," sec>total\n"
