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
#
# Indexes
#
#  index_invitations_on_event_id         (event_id)
#  index_invitations_on_family_group_id  (family_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (family_group_id => family_groups.id)
#
class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :family_group, optional: true

  enum :status, { pending: 0, accepted: 1, declined: 2 }

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
