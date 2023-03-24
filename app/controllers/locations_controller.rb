class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end

  def create
    @location = Location.create(location_params)

    if @location.save
      render 'locations/create', status: :created
    else
      render 'errors/error', locals: { object: @location }, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
