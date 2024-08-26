class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: true, length: { is: 10 }, format: { with: /\A\d{10}\z/, message: "must be a 10-digit number" }
  validates :password, confirmation: true, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password_confirmation, presence: true
  # validate :password_validate
  
  private

  def password_required?
    new_record? || !password.nil?
  end
  # def password_validate
  #   format = password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z\d]).{8,}$/)
  #     errors.add(:password, 'must include at least one uppercase letter, one lowercase letter, one digit, and one special character') unless format
  # end
end
