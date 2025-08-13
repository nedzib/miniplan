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
require "test_helper"

class LineaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
