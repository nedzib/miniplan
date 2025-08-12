class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
