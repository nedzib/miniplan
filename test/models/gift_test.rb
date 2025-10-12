# == Schema Information
#
# Table name: gifts
#
#  id           :bigint           not null, primary key
#  description  :text
#  name         :string
#  purchased_by :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  event_id     :bigint           not null
#
# Indexes
#
#  index_gifts_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require "test_helper"

class GiftTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
