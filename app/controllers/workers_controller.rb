class WorkersController < ApplicationController
  def index
    @workers = Worker.all
  end

  def create
    @worker = Worker.create(worker_params)

    if @worker.save
      @worker
    else
      @errors = @worker.errors.full_messages
      render json: {
        "error": {
          "message": @errors[0],
          "code": 002,
          "object": "worker",
          "index": 0
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :location_id)
  end
end
