class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 50

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
