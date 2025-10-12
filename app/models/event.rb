# == Schema Information
#
# Table name: events
#
#  id            :bigint           not null, primary key
#  description   :text
#  end_time      :datetime
#  location      :string
#  map_url       :string
#  rsvp_deadline :datetime
#  start_time    :datetime
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  hash_id       :string
#  theme_id      :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_events_on_hash_id   (hash_id) UNIQUE
#  index_events_on_theme_id  (theme_id)
#  index_events_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (theme_id => event_themes.id)
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :theme, class_name: "EventTheme", optional: true, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :family_groups, dependent: :destroy
  has_many :presupuestos, dependent: :destroy
  has_many :gifts, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :location, length: { maximum: 255 }
  validates :map_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validates :start_time, presence: true
  validates :hash_id, presence: true, uniqueness: true

  before_validation :generate_hash_id, if: -> { hash_id.blank? }
  after_create :create_default_theme

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

  def to_param
    hash_id
  end

  def current_theme
    theme || create_default_theme
  end

  private

  def generate_hash_id
    loop do
      self.hash_id = SecureRandom.hex(16)
      break unless Event.exists?(hash_id: hash_id)
    end
  end

  def create_default_theme
    return theme if theme.present?

    new_theme = EventTheme.create!(
      name: "Tema de #{title}",
      primary_color: "#d4a574",
      secondary_color: "#90c695",
      contrast_mode: "dark",
      background_gradient: "linear-gradient(135deg, #fdf4e3 0%, #f5e6d3 50%, #e8d5b7 100%)",
      floating_elements: [
        { emoji: "🌻", top: "10%", left: "5%", size: "2rem" },
        { emoji: "✌️", top: "15%", right: "8%", size: "1.5rem" },
        { emoji: "🌿", top: "25%", left: "15%", size: "1.8rem" },
        { emoji: "☮️", top: "35%", right: "20%", size: "2.2rem" },
        { emoji: "🦋", top: "45%", left: "8%", size: "1.6rem" },
        { emoji: "🍄", top: "55%", right: "12%", size: "1.9rem" },
        { emoji: "🦋", top: "65%", left: "25%", size: "1.7rem" },
        { emoji: "🌸", top: "75%", right: "15%", size: "2rem" }
      ].to_json,
      header_emoji: "🌻,✌️,🌸",
      title_template: "¡Te invitamos a nuestro {title}! 🌻✌️",
      subtitle_template: "Querida alma {name} 🌻",
      description_emojis: "🌻 ✌️ 🌿 ☮️ 🦋",
      accept_emoji: "🌻",
      decline_emoji: "🌙",
      accept_text: "¡Sí, me uno al gathering!",
      decline_text: "No podré ir esta vez",
      success_message: "¡Excelente! Tu alma fluirá en armonía con nuestro gathering especial.",
      decline_message: "Lamentamos que no puedas fluir hasta nuestro gathering.",
      footer_message: "Si tienes alguna pregunta, fluye hasta nosotros con amor y paz. 🌻✌️",
      status_accepted_emoji: "🌻",
      status_declined_emoji: "🌙",
      status_pending_emoji: "🌻",
      date_icon: "⏰",
      location_icon: "🌍",
      gifts_icon: "🎁"
    )

    update_column(:theme_id, new_theme.id) if persisted?
    new_theme
  end

  def end_time_after_start_time
    return unless end_time && start_time

    errors.add(:end_time, "must be after the start time") if end_time < start_time
  end

  def rsvp_deadline_before_start_time
    return unless rsvp_deadline && start_time

    errors.add(:rsvp_deadline, "must be before the event start time") if rsvp_deadline > start_time
  end
end
