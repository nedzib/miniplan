class CreateGifts < ActiveRecord::Migration[8.0]
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :description
      t.string :purchased_by
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
