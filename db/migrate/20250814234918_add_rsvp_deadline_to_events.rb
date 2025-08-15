class AddRsvpDeadlineToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :rsvp_deadline, :datetime
  end
end
