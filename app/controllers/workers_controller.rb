class WorkersController < ApplicationController
  def index
    @workers = Worker.all
  end

  def create
    @worker = Worker.create(worker_params)

    if @worker.save
      render 'workers/create', status: :created
    else
      render 'errors/error', locals: { object: @worker }, formats: :json, status: :unprocessable_entity
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :location_id)
  end
end
