class WorkersController < ApplicationController
  def index
    @workers = Worker.all
    render json: { data: @workers }
  end

  def create
    @worker = Worker.create(worker_params)
    render json: {
      "data": {
        "id": @worker.id,
        "name": @worker.name,
        "location": @worker.location.name,
        "year_in_work": @worker.year_in_work,
        # "worker_couples": [],
      }
    }
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :location_id)
  end
end
