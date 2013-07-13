class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
#      format.xml  { render xml:  @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @scores = ["","","","",""]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @scores = []
    5.times {|i|
      input = Input.where(:task_id=>params[:id],:name=>i.to_s).first
      @scores << (input ? input.score.to_s : "")
    }
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    id = @task.id
    respond_to do |format|
      if @task.save
        id = @task.id
        Dir::mkdir("task_data/#{id}") if !File.exist?("task_data/#{id}")
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
        5.times { |ii|
          inputs = params[:task_data]["in#{ii}"]
          outputs = params[:task_data]["out#{ii}"]
          score = params[:task_data]["score#{ii}"]
          dir = "task_data/#{id}"
          if outputs && inputs
            inputs.sort!{|a,b| a.original_filename<=>b.original_filename}
            outputs.sort!{|a,b| a.original_filename<=>b.original_filename}
            p "score#{score}"
            Dir::mkdir("#{dir}/#{ii}") if !File.exist?("#{dir}/#{ii}")
            Dir::mkdir("#{dir}/#{ii}/in") if !File.exist?("#{dir}/#{ii}/in")
            Dir::mkdir("#{dir}/#{ii}/out") if !File.exist?("#{dir}/#{ii}/out")
            outputs.length.times { |j|
              i = inputs[j]
              o = outputs[j]
              File.open("#{dir}/#{ii}/in/#{i.original_filename}", 'w') do |f|
                f.write(i.read)
              end
              File.open("#{dir}/#{ii}/out/#{o.original_filename}", 'w') do |f|
                f.write(o.read)
              end
            }
            input = (Input.exists?(:task_id=>id,:name=>ii.to_s))?(Input.where(:task_id=>id,:name=>ii.to_s).first):(Input.new)
            input.score = score
            input.task_id = id
            input.name = ii.to_s
            input.save
          elsif score.to_s.length==0
            system("rm -r #{dir}/#{ii}")
            Input.where(:task_id=>id,:name=>ii.to_s).first.destroy if Input.exists?(:task_id=>id,:name=>ii.to_s)
          elsif score.to_s.length>0
            input = (Input.exists?(:task_id=>id,:name=>ii.to_s))?(Input.where(:task_id=>id,:name=>ii.to_s).first):(Input.new)
            input.score = score
            input.save
          end
        }

      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    id = params[:id]
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
        5.times { |ii|
          inputs = params[:task_data]["in#{ii}"]
          outputs = params[:task_data]["out#{ii}"]
          score = params[:task_data]["score#{ii}"]
          dir = "task_data/#{id}"
          if outputs && inputs
            inputs.sort!{|a,b| a.original_filename<=>b.original_filename}
            outputs.sort!{|a,b| a.original_filename<=>b.original_filename}
            p "score#{score}"
            Dir::mkdir("#{dir}/#{ii}") if !File.exist?("#{dir}/#{ii}")
            Dir::mkdir("#{dir}/#{ii}/in") if !File.exist?("#{dir}/#{ii}/in")
            Dir::mkdir("#{dir}/#{ii}/out") if !File.exist?("#{dir}/#{ii}/out")
            outputs.length.times { |j|
              i = inputs[j]
              o = outputs[j]
              File.open("#{dir}/#{ii}/in/#{i.original_filename}", 'w') do |f|
                f.write(i.read)
              end
              File.open("#{dir}/#{ii}/out/#{o.original_filename}", 'w') do |f|
                f.write(o.read)
              end
            }
            input = (Input.exists?(:task_id=>id,:name=>ii.to_s))?(Input.where(:task_id=>id,:name=>ii.to_s).first):(Input.new)
            input.score = score
            input.task_id = id
            input.name = ii.to_s
            input.save
          elsif score.to_s.length==0
            system("rm -r #{dir}/#{ii}")
            Input.where(:task_id=>id,:name=>ii.to_s).first.destroy if Input.exists?(:task_id=>id,:name=>ii.to_s)
          elsif score.to_s.length>0
            input = (Input.exists?(:task_id=>id,:name=>ii.to_s))?(Input.where(:task_id=>id,:name=>ii.to_s).first):(Input.new)
            input.score = score
            input.save
          end
        }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
end
