class AddMapUrlToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :map_url, :string
  end
end
