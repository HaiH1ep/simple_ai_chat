class LinkedinConnectionsController < ApplicationController
  before_action :set_linkedin_connection, only: %i[ show edit update destroy ]

  # GET /linkedin_connections or /linkedin_connections.json
  def index
    @linkedin_connections = LinkedinConnection.all
  end

  # GET /linkedin_connections/1 or /linkedin_connections/1.json
  def show
  end

  # GET /linkedin_connections/new
  def new
    @linkedin_connection = LinkedinConnection.new
  end

  # GET /linkedin_connections/1/edit
  def edit
  end

  # POST /linkedin_connections or /linkedin_connections.json
  def create
    @linkedin_connection = LinkedinConnection.new(linkedin_connection_params)

    respond_to do |format|
      if @linkedin_connection.save
        format.html { redirect_to linkedin_connection_url(@linkedin_connection), notice: "Linkedin connection was successfully created." }
        format.json { render :show, status: :created, location: @linkedin_connection }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @linkedin_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /linkedin_connections/1 or /linkedin_connections/1.json
  def update
    respond_to do |format|
      if @linkedin_connection.update(linkedin_connection_params)
        format.html { redirect_to linkedin_connection_url(@linkedin_connection), notice: "Linkedin connection was successfully updated." }
        format.json { render :show, status: :ok, location: @linkedin_connection }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @linkedin_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /linkedin_connections/1 or /linkedin_connections/1.json
  def destroy
    @linkedin_connection.destroy!

    respond_to do |format|
      format.html { redirect_to linkedin_connections_url, notice: "Linkedin connection was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_linkedin_connection
      @linkedin_connection = LinkedinConnection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def linkedin_connection_params
      params.require(:linkedin_connection).permit(:first_name, :last_name, :email, :position, :company, :profile_url, :connected_on)
    end
end
