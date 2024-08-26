require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(20) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value('test@example.com').for(:email) }
  it { should_not allow_value('invalid-email').for(:email) }
  it { should validate_presence_of(:phone_number) }
  it { should validate_uniqueness_of(:phone_number).case_insensitive }
  it { should allow_value('1234567890').for(:phone_number) }
  it { should_not allow_value('123456789').for(:phone_number).with_message('must be a 10-digit number') }
  it { should_not allow_value('12345678901').for(:phone_number).with_message('must be a 10-digit number') }
  it { should_not allow_value('abcdefghij').for(:phone_number).with_message('must be a 10-digit number') }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(8) }

  describe 'password validation' do
    it 'is required on creation' do
      user = User.new(name: 'Test User', email: 'test@example.com', phone_number: '1234567890')
      expect(user.valid?).to be_falsey
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
end
