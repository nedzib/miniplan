# == Schema Information
#
# Table name: family_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#
# Indexes
#
#  index_family_groups_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class FamilyGroup < ApplicationRecord
  belongs_to :event
  has_many :invitations, dependent: :nullify
  has_many :users, through: :invitations

  validates :name, presence: true
end
