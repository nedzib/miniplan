# == Schema Information
#
# Table name: presupuestos
#
#  id          :bigint           not null, primary key
#  description :text
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  event_id    :bigint           not null
#
# Indexes
#
#  index_presupuestos_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require "test_helper"

class PresupuestoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
