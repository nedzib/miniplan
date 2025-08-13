class CreateLineas < ActiveRecord::Migration[8.0]
  def change
    create_table :lineas do |t|
      t.references :presupuesto, null: false, foreign_key: true
      t.string :concepto, null: false
      t.integer :valor_cents, null: false
      t.string :valor_currency, default: 'USD'
      t.boolean :por_persona, default: false

      t.timestamps
    end
  end
end
