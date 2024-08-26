class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :phone_number, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :otp

      t.timestamps
    end
  end
end