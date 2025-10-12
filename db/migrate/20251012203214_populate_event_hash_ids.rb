class PopulateEventHashIds < ActiveRecord::Migration[8.0]
  def up
    Event.where(hash_id: nil).find_each do |event|
      loop do
        hash_id = SecureRandom.hex(16)
        unless Event.exists?(hash_id: hash_id)
          event.update_column(:hash_id, hash_id)
          break
        end
      end
    end
  end

  def down
    # No necesitamos revertir, ya que los hash_ids pueden quedarse
  end
end
