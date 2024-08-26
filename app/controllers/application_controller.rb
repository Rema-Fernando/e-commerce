class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def decode_token
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    JWT.decode(header, Rails.application.secrets.secret_key_base)[0]
  rescue JWT::DecodeError
    nil
  end

  def authorize_request
    decoded = decode_token
    @current_user = User.find(decoded['user_id']) if decoded
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
