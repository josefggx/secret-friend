class LocationsController < ApplicationController
  def index
    @locations = Location.all
    render json: { data: @locations }
  end

  def create
    @location = Location.create(location_params)
    render json: { data: @location }
  end

  private

  def location_params
    params.require(:location).permit(:name)
  end
end
