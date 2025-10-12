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

  def card_class
    case theme
    when "bee"
      "bee-detail-card"
    else
      "hippie-detail-card"
    end
  end

  def icon_wrapper_class
    case theme
    when "bee"
      "bee-icon-wrapper flex-shrink-0"
    else
      "hippie-icon-wrapper"
    end
  end

  def icon_class
    case theme
    when "bee"
      "bee-icon text-lg sm:text-xl"
    else
      "text-lg sm:text-xl"
    end
  end

  def title_style
    case theme
    when "bee"
      "color: var(--bee-black);"
    else
      "color: #8b4513;"
    end
  end

  def content_style
    case theme
    when "bee"
      "color: var(--bee-brown);"
    else
      "color: #5d4e37;"
    end
  end

  def button_style
    case theme
    when "bee"
      "background: linear-gradient(135deg, #9f7aea 0%, #e9d5ff 100%); border: 2px solid #8b5cf6; color: black;"
    else
      "background: linear-gradient(135deg, #d4a574 0%, #e6c994 100%); border: 2px solid #c49a6c; color: white;"
    end
  end

  def show_button?
    url.present? && button_title.present?
  end
end
