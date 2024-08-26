class UsersController < ApplicationController
  def signup
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def login
    if params[:email].present?
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = encode_token(user_id: user.id)
        render json: { message: "Login Successful", token: token }, status: 200
      else
        render json: { error: 'Invalid email or password' }, status: 401
      end
    elsif params[:phone_number].present?
      user = User.find_by(phone_number: params[:phone_number])
      if user
        otp = send_otp(user)
        render json: { message: 'OTP sent to your phone number', otp: otp }, status: 200
      else
        render json: { error: 'Invalid phone number' }, status: 401
      end
    else
      render json: { error: 'Email or phone number required' }, status: 400
    end
  end

  def verify_otp
    user = User.find_by(phone_number: params[:phone_number])
    binding.pry
    if user&.otp == params[:otp]
      token = encode_token(user_id: user.id)
      render json: { message: "Login Successful", token: token }, status: 200
    else
      render json: { error: 'Invalid OTP' }, status: 401
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone_number, :password, :password_confirmation)
  end

  def send_otp(user)
    otp = rand(1000..9999).to_s
    user.update(otp: otp)
    otp
  end
end
