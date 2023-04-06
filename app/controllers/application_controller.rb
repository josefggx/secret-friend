class ApplicationController < ActionController::Base
  before_action :set_default_response_format

  protect_from_forgery with: :null_session,
                       if: proc { |c| c.request.format =~ %r{application/json} }

  private

  def set_default_response_format
    request.format = :json
  end
end
