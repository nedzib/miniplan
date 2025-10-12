class BackfillEventThemes < ActiveRecord::Migration[8.0]
  def up
    # Crear un tema personalizado para cada evento existente
    Event.includes(:theme).where(theme_id: nil).find_each do |event|
      theme = EventTheme.create!(
        name: "Tema de #{event.title}",
        primary_color: '#d4a574',
        secondary_color: '#90c695',
        contrast_mode: 'dark',
        background_gradient: 'linear-gradient(135deg, #fdf4e3 0%, #f5e6d3 50%, #e8d5b7 100%)',
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
        title_template: "¡Te invitamos a nuestro gathering! 🌻✌️",
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
      
      event.update!(theme_id: theme.id)
    end
  end

  def down
    # Eliminar temas creados y remover asignaciones
    Event.update_all(theme_id: nil)
    EventTheme.delete_all
  end
end
