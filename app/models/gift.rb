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
class Gift < ApplicationRecord
  belongs_to :event

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }

  # Evitar regalos duplicados por nombre en el mismo evento
  validates :name, uniqueness: { scope: :event_id, case_sensitive: false,
                                message: "Este regalo ya fue registrado por alguien más" }

  scope :recent, -> { order(created_at: :desc) }
end
