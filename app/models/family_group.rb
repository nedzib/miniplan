# == Schema Information
#
# Table name: family_groups
#
#  id         :bigint           not null, primary key
#  hash_id    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
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
class FamilyGroup < ApplicationRecord
  belongs_to :event
  has_many :invitations, dependent: :nullify
  has_many :users, through: :invitations

  validates :name, presence: true
  validates :hash_id, presence: true, uniqueness: true

  before_validation :generate_hash_id, if: -> { hash_id.blank? }

  def to_param
    hash_id
  end

  private

  def generate_hash_id
    loop do
      self.hash_id = SecureRandom.hex(16)
      break unless FamilyGroup.exists?(hash_id: hash_id)
    end
  end
end
