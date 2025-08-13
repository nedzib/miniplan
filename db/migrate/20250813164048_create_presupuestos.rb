class CreatePresupuestos < ActiveRecord::Migration[8.0]
  def change
    create_table :presupuestos do |t|
      t.references :event, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
