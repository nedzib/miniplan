# == Schema Information
#
# Table name: family_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  hash_id    :string
#
# Indexes
#
#  index_family_groups_on_event_id  (event_id)
#  index_family_groups_on_hash_id   (hash_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
require "test_helper"

class FamilyGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
