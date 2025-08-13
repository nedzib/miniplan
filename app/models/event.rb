# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text
#  end_time    :datetime
#  location    :string
#  start_time  :datetime
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  has_many :invitations, dependent: :destroy
  has_many :family_groups, dependent: :destroy
  has_many :presupuestos, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :location, length: { maximum: 255 }
  validates :start_time, presence: true
  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  scope :upcoming, -> { where("start_time > ?", Time.current) }
  scope :past, -> { where("start_time < ?", Time.current) }
  scope :today, -> { where(start_time: Date.current.beginning_of_day..Date.current.end_of_day) }

  private

  def end_time_after_start_time
    return unless end_time && start_time

    errors.add(:end_time, "must be after the start time") if end_time < start_time
  end
end
