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
require "test_helper"

class EventThemeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
