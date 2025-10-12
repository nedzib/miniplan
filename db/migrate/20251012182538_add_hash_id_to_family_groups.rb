class AddHashIdToFamilyGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :family_groups, :hash_id, :string
    add_index :family_groups, :hash_id, unique: true
  end
end
