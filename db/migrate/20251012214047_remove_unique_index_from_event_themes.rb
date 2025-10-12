class RemoveUniqueIndexFromEventThemes < ActiveRecord::Migration[8.0]
  def change
    remove_index :event_themes, :name
    add_index :event_themes, :name
  end
end
