class InputsController < ApplicationController
  # GET /inputs
  # GET /inputs.json
  def index
    @inputs = Input.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inputs }
    end
  end

  # GET /inputs/1
  # GET /inputs/1.json
  def show
    @input = Input.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @input }
    end
  end

  # GET /inputs/new
  # GET /inputs/new.json
  def new
    @input = Input.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @input }
    end
  end

  # GET /inputs/1/edit
  def edit
    @input = Input.find(params[:id])
  end

  # POST /inputs
  # POST /inputs.json
  def create
    @input = Input.new(params[:input])

    respond_to do |format|
      if @input.save
        format.html { redirect_to @input, notice: 'Input was successfully created.' }
        format.json { render json: @input, status: :created, location: @input }
      else
        format.html { render action: "new" }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inputs/1
  # PUT /inputs/1.json
  def update
    @input = Input.find(params[:id])

    respond_to do |format|
      if @input.update_attributes(params[:input])
        format.html { redirect_to @input, notice: 'Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inputs/1
  # DELETE /inputs/1.json
  def destroy
    @input = Input.find(params[:id])
    @input.destroy

    respond_to do |format|
      format.html { redirect_to inputs_url }
      format.json { head :no_content }
    end
  end
end
