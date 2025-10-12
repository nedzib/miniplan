class PopulateHashIdForExistingFamilyGroups < ActiveRecord::Migration[8.0]
  def up
    FamilyGroup.where(hash_id: nil).find_each do |family_group|
      loop do
        hash_id = SecureRandom.hex(16)
        unless FamilyGroup.exists?(hash_id: hash_id)
          family_group.update_column(:hash_id, hash_id)
          break
        end
      end
    end
  end

  def down
    # No need to reverse this
  end
end
