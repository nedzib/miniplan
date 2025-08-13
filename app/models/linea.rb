# == Schema Information
#
# Table name: lineas
#
#  id             :bigint           not null, primary key
#  concepto       :string           not null
#  por_persona    :boolean          default(FALSE)
#  valor_cents    :integer          not null
#  valor_currency :string           default("USD")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  presupuesto_id :bigint           not null
#
# Indexes
#
#  index_lineas_on_presupuesto_id  (presupuesto_id)
#
# Foreign Keys
#
#  fk_rails_...  (presupuesto_id => presupuestos.id)
#
class Linea < ApplicationRecord
  belongs_to :presupuesto

  validates :concepto, presence: true
  validates :valor_cents, presence: true, numericality: { greater_than: 0 }
  validates :por_persona, inclusion: { in: [ true, false ] }

  before_validation :set_default_currency

  # Método para obtener el valor en centavos
  def valor
    valor_cents
  end

  # Método para establecer el valor desde un número decimal
  def valor=(amount)
    if amount.is_a?(String)
      amount = amount.to_f
    end
    self.valor_cents = (amount.to_f * 100).to_i
  end

  private

  def set_default_currency
    self.valor_currency ||= "USD"
  end
end
