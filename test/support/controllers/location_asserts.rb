# frozen_string_literal: true

module LocationAsserts
  def location_response_asserts
    location = Location.find(response_data['id'])
    assert_equal create_location_valid_keys, response_data.keys, 'Create location response'
    assert_equal location.id, response_data['id']
    assert_equal location.name, response_data['name']
  end
end
