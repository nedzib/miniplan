# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  description   :text
#  end_time      :datetime
#  location      :string
#  rsvp_deadline :datetime
#  start_time    :datetime
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
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
  validate :rsvp_deadline_before_start_time, if: -> { rsvp_deadline.present? && start_time.present? }

  scope :upcoming, -> { where("start_time > ?", Time.current) }
  scope :past, -> { where("start_time < ?", Time.current) }
  scope :today, -> { where(start_time: Date.current.beginning_of_day..Date.current.end_of_day) }

  def rsvp_deadline_passed?
    return false unless rsvp_deadline
    Time.current > rsvp_deadline
  end

  def rsvp_deadline_active?
    return true unless rsvp_deadline
    Time.current <= rsvp_deadline
  end

  private

  def end_time_after_start_time
    return unless end_time && start_time

    errors.add(:end_time, "must be after the start time") if end_time < start_time
  end

  def rsvp_deadline_before_start_time
    return unless rsvp_deadline && start_time

    errors.add(:rsvp_deadline, "must be before the event start time") if rsvp_deadline > start_time
  end
end
