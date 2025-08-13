# == Schema Information
#
# Table name: invitations
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string           not null
#  phone           :string
#  status          :integer          default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :bigint           not null
#  family_group_id :bigint
#  hash_id         :string
#
# Indexes
#
#  index_invitations_on_event_id         (event_id)
#  index_invitations_on_family_group_id  (family_group_id)
#  index_invitations_on_hash_id          (hash_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (family_group_id => family_groups.id)
#
require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
