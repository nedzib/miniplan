class CreateFamilyGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :family_groups do |t|
      t.string :name
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
