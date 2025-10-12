class AddThemeToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :theme, null: true, foreign_key: { to_table: :event_themes }
  end
end
