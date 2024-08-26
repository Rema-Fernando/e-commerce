# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    { name: 'Rema', email: 'rema@example.com', phone_number: '9876543210', password: 'password@123', password_confirmation: 'password@123' }
  }

  let(:invalid_attributes) {
    { name: '', email: 'invalid', phone_number: '123', password: 'short', password_confirmation: 'short' }
  }

  describe "POST #signup" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :signup, params: valid_attributes
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('User created successfully')
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :signup, params: invalid_attributes
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Email is invalid", "Phone number is the wrong length (should be 10 characters)", "Password is too short (minimum is 8 characters)")
      end
    end
  end

  describe "POST #login" do
    let!(:user) { FactoryBot.create(:user) }

    context "with valid email and password" do
      it "logs in the user" do
        post :login, params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login Successful')
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context "with valid phone number" do
      it "sends an OTP" do
        post :login, params: { phone_number: user.phone_number }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('OTP sent to your phone number')
        expect(JSON.parse(response.body)['otp']).not_to be_nil
      end
    end

    context "with invalid email or phone number" do
      it "returns an error" do
        post :login, params: { email: 'invalid@example.com' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end

  describe "POST #verify_otp" do
    let!(:user) { FactoryBot.create(:user, otp: '1234') }

    context "with valid OTP" do
      it "logs in the user" do
        post :verify_otp, params: { phone_number: user.phone_number, otp: '1234' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login Successful')
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end
    end

    context "with invalid OTP" do
      it "returns an error" do
        post :verify_otp, params: { phone_number: user.phone_number, otp: '0000' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid OTP')
      end
    end
  end
end