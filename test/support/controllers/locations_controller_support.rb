# frozen_string_literal: true

module LocationsControllerSupport
  def location_params
    {
      location: {
        name: 'New Location'
      }
    }
  end

  def invalid_location_params
    {
      location: {
        name: 'In'
      }
    }
  end

  def create_location_valid_keys
    %w[id name]
  end
end
