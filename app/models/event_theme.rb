# == Schema Information
#
# Table name: event_themes
#
#  id                    :bigint           not null, primary key
#  accept_emoji          :string
#  accept_text           :string
#  background_gradient   :text
#  button_style_class    :string
#  card_style_class      :string
#  contrast_mode         :string           default("dark"), not null
#  date_icon             :string           default("⏰")
#  decline_emoji         :string
#  decline_message       :text
#  decline_text          :string
#  description_emojis    :string
#  floating_elements     :text
#  footer_message        :text
#  gifts_icon            :string           default("🎁")
#  header_emoji          :string
#  location_icon         :string           default("🌍")
#  name                  :string           not null
#  primary_color         :string           not null
#  secondary_color       :string           not null
#  status_accepted_emoji :string
#  status_declined_emoji :string
#  status_pending_emoji  :string
#  subtitle_template     :string
#  success_message       :text
#  title_template        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_event_themes_on_name  (name)
#
class EventTheme < ApplicationRecord
  has_one :event

  validates :name, presence: true
  validates :primary_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "debe ser un color hexadecimal válido" }
  validates :secondary_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "debe ser un color hexadecimal válido" }
  validates :contrast_mode, presence: true, inclusion: { in: %w[light dark], message: "debe ser 'light' o 'dark'" }

  # Métodos para obtener configuraciones con valores por defecto
  def header_emojis
    return ["🌻", "✌️", "🌸"] if header_emoji.blank?
    header_emoji.split(",").map(&:strip)
  end

  def floating_elements_array
    return default_floating_elements if floating_elements.blank?
    JSON.parse(floating_elements)
  rescue JSON::ParserError
    default_floating_elements
  end

  def text_color
    contrast_mode == 'dark' ? '#ffffff' : '#000000'
  end

  def background_text_color
    contrast_mode == 'dark' ? '#2d3748' : '#1a202c'
  end

  def card_background
    "rgba(255, 255, 255, #{contrast_mode == 'dark' ? '0.9' : '0.95'})"
  end

  def generate_css_variables
    {
      '--theme-primary': primary_color,
      '--theme-secondary': secondary_color,
      '--theme-text': text_color,
      '--theme-bg-text': background_text_color,
      '--theme-card-bg': card_background
    }
  end

  def safe_title_template
    title_template.presence || "¡Te invitamos a nuestro {type}! {emoji}"
  end

  def safe_subtitle_template
    subtitle_template.presence || "Querida alma {name} {emoji}"
  end

  def safe_accept_text
    accept_text.presence || "¡Sí, me uno!"
  end

  def safe_decline_text
    decline_text.presence || "No podré ir esta vez"
  end

  def safe_success_message
    success_message.presence || "¡Excelente! Tu presencia está confirmada en armonía."
  end

  def safe_decline_message
    decline_message.presence || "Lamentamos que no puedas acompañarnos en esta ocasión."
  end

  def safe_footer_message
    footer_message.presence || "Si tienes alguna pregunta, no dudes en contactarnos."
  end

  def interpolate_template(template, variables = {})
    result = template.dup
    variables.each do |key, value|
      result.gsub!("{#{key}}", value.to_s)
    end
    result
  end

  private

  def default_floating_elements
    [
      { emoji: "🌻", top: "10%", left: "5%", size: "2rem" },
      { emoji: "✌️", top: "15%", right: "8%", size: "1.5rem" },
      { emoji: "🌿", top: "25%", left: "15%", size: "1.8rem" },
      { emoji: "☮️", top: "35%", right: "20%", size: "2.2rem" },
      { emoji: "🦋", top: "45%", left: "8%", size: "1.6rem" },
      { emoji: "🍄", top: "55%", right: "12%", size: "1.9rem" },
      { emoji: "🦋", top: "65%", left: "25%", size: "1.7rem" },
      { emoji: "🌸", top: "75%", right: "15%", size: "2rem" }
    ]
  end
end
