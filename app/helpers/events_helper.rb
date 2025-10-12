module EventsHelper
  def public_gifts_url_for_event(event)
    public_gifts_url(event.hash_id)
  end

  def share_gifts_text(event)
    "🎁 Lista de Regalos para #{event.title} - ¡Registra tu regalo para evitar duplicados! #{public_gifts_url_for_event(event)}"
  end
end
