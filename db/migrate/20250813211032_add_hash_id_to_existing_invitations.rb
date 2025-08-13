class AddHashIdToExistingInvitations < ActiveRecord::Migration[8.0]
  def up
    # Generar hash_id para invitaciones que no lo tengan
    Invitation.where(hash_id: [nil, ""]).find_each do |invitation|
      loop do
        hash_id = SecureRandom.hex(16)
        unless Invitation.exists?(hash_id: hash_id)
          invitation.update_column(:hash_id, hash_id)
          break
        end
      end
    end
  end

  def down
    # No hacer nada en el rollback ya que no queremos borrar hash_ids
  end
end
