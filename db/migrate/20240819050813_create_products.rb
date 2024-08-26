class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :title, null: false
      t.float :price, null: false
      t.integer :quantity, null: false
      t.text :highlights, null: false
      t.text :detailed_description, null: false
      t.boolean :assured, null: false
      t.references :category, null: false, foreign_key: true


      t.timestamps
    end
  end
end
