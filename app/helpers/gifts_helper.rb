module GiftsHelper
  def gift_icon_for_category(gift_name)
    name_lower = gift_name.downcase

    case name_lower
    when /libro|revista|lectura/
      "📚"
    when /ropa|vestido|camisa|pantalon|zapato/
      "👕"
    when /cocina|vajilla|plato|vaso|cubierto/
      "🍽️"
    when /electronico|telefono|computador|tablet/
      "📱"
    when /juguete|peluche|muneco/
      "🧸"
    when /joya|collar|anillo|pulsera/
      "💍"
    when /hogar|decoracion|lampara|cuadro/
      "🏠"
    when /deporte|ejercicio|gimnasio/
      "⚽"
    when /musica|instrumento|auricular/
      "🎵"
    when /belleza|cosmetico|perfume|crema/
      "💄"
    else
      "🎁"
    end
  end

  def format_gift_date(date)
    if date >= 1.day.ago
      "Hace #{time_ago_in_words(date)}"
    else
      date.strftime("%d/%m/%Y")
    end
  end

  def gifts_summary_text(gifts_count, people_count)
    if gifts_count == 0
      t("gifts.no_gifts_yet")
    elsif gifts_count == 1
      "1 #{t('gifts.title').downcase} registrado por 1 persona"
    else
      "#{gifts_count} #{t('gifts.title').downcase} registrados por #{people_count} #{people_count == 1 ? 'persona' : 'personas'}"
    end
  end

  def share_gifts_text(event)
    t("gifts.share_text", event_title: event.title)
  end

  # Para pasar traducciones a JavaScript
  def gifts_js_translations
    {
      link_copied: t("gifts.link_copied"),
      share_title: "#{t('gifts.title')} - #{@event.title}",
      share_text: "#{gifts_icon} #{t('gifts.share_text', event_title: @event.title)}"
    }.to_json.html_safe
  end

  private

  def gifts_icon
    @event&.current_theme&.gifts_icon || "🎁"
  end
end
