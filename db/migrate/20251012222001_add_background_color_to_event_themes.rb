class AddBackgroundColorToEventThemes < ActiveRecord::Migration[8.0]
  def change
    add_column :event_themes, :background_color, :string
  end
end
