class AddHashIdToInvitations < ActiveRecord::Migration[8.0]
  def change
    add_column :invitations, :hash_id, :string
    add_index :invitations, :hash_id, unique: true

    # Generate hash_id for existing invitations
    reversible do |dir|
      dir.up do
        Invitation.find_each do |invitation|
          invitation.update_column(:hash_id, SecureRandom.hex(16))
        end
      end
    end
  end
end
