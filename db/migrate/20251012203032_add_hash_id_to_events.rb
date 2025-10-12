class AddHashIdToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :hash_id, :string
    add_index :events, :hash_id, unique: true
  end
end
