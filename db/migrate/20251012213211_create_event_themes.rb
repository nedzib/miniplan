class CreateEventThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :event_themes do |t|
      t.string :name, null: false
      t.string :primary_color, null: false
      t.string :secondary_color, null: false
      t.string :contrast_mode, null: false, default: 'dark' # 'dark' or 'light'
      t.text :background_gradient
      t.text :floating_elements # JSON array de emojis con posiciones
      t.string :header_emoji
      t.string :title_template
      t.string :subtitle_template
      t.string :description_emojis
      t.string :accept_emoji
      t.string :decline_emoji
      t.string :accept_text
      t.string :decline_text
      t.text :success_message
      t.text :decline_message
      t.text :footer_message
      t.string :status_accepted_emoji
      t.string :status_declined_emoji
      t.string :status_pending_emoji
      t.string :date_icon, default: "⏰"
      t.string :location_icon, default: "🌍"
      t.string :gifts_icon, default: "🎁"
      t.string :button_style_class
      t.string :card_style_class

      t.timestamps
    end

    add_index :event_themes, :name, unique: true
  end
end
