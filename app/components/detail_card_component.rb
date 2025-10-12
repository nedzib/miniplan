class DetailCardComponent < ViewComponent::Base
  def initialize(icon:, title:, body:, url: nil, button_title: nil, theme: "hippie")
    @icon = icon
    @title = title
    @body = body
    @url = url
    @button_title = button_title
    @theme = theme
  end

  private

  attr_reader :icon, :title, :body, :url, :button_title, :theme

  def theme_object
    @theme_object ||= theme.is_a?(String) ? nil : theme
  end

  def card_class
    if theme_object
      "detail-card"
    elsif theme == "bee"
      "bee-detail-card"
    else
      "hippie-detail-card"
    end
  end

  def icon_wrapper_class
    if theme_object
      "icon-wrapper flex-shrink-0"
    elsif theme == "bee"
      "bee-icon-wrapper flex-shrink-0"
    else
      "hippie-icon-wrapper"
    end
  end

  def icon_class
    "text-lg sm:text-xl"
  end

  def card_style
    if theme_object
      "background: #{theme_object.card_background}; border: 2px solid #{theme_object.secondary_color}; border-radius: 15px; padding: 1rem; display: flex; align-items: flex-start; gap: 0.75rem;"
    else
      ""
    end
  end

  def icon_wrapper_style
    if theme_object
      "background: linear-gradient(135deg, #{theme_object.primary_color} 0%, #{theme_object.secondary_color} 100%); border-radius: 50%; width: 2.5rem; height: 2.5rem; display: flex; align-items: center; justify-content: center; border: 2px solid #{theme_object.primary_color}; flex-shrink: 0;"
    else
      ""
    end
  end

  def title_style
    if theme_object
      "color: #{theme_object.background_text_color};"
    elsif theme == "bee"
      "color: var(--bee-black);"
    else
      "color: #8b4513;"
    end
  end

  def content_style
    if theme_object
      "color: #{theme_object.background_text_color};"
    elsif theme == "bee"
      "color: var(--bee-brown);"
    else
      "color: #5d4e37;"
    end
  end

  def button_style
    if theme_object
      "background: linear-gradient(135deg, #{theme_object.primary_color} 0%, #{theme_object.secondary_color} 100%); border: 2px solid #{theme_object.primary_color}; color: #{theme_object.text_color};"
    elsif theme == "bee"
      "background: linear-gradient(135deg, #9f7aea 0%, #e9d5ff 100%); border: 2px solid #8b5cf6; color: black;"
    else
      "background: linear-gradient(135deg, #d4a574 0%, #e6c994 100%); border: 2px solid #c49a6c; color: white;"
    end
  end

  def show_button?
    url.present? && button_title.present?
  end
end
