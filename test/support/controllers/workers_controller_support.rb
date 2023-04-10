# frozen_string_literal: true

module WorkersControllerSupport
  def worker_params
    {
      worker: {
        name: 'New Location',
        location_id: locations(:location_one).id
      }
    }
  end

  def invalid_worker_params
    {
      worker: {
        name: 'In',
        location_id: locations(:location_one).id
      }
    }
  end

  def create_worker_valid_keys
    %w[id name location year_in_work]
  end
end
