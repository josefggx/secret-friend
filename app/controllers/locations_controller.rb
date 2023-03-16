class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def create
    @location = Location.create(location_params)

    if @location.save
      @location
    else
      @errors = @location.errors.full_messages
      render json: @location.errors, status: :unprocessable_entity
      # render json: {
      #   "errors": {
      #     "message": @errors,
      #     "code": 002,
      #     "object": "worker",
      #     "index": 0
      #   }
      # }, status: :unprocessable_entity
      end
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
