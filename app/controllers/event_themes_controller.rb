class EventThemesController < ApplicationController
  include EventFinder

  before_action :set_event
  before_action :set_theme
  before_action :ensure_owner!

  def show
    redirect_to edit_event_theme_path(@event)
  end

  def edit
  end

  def update
    if @theme.update(theme_params)
      redirect_to edit_event_theme_path(@event),
                  notice: "Tema actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_event
    event = find_event_by_param(params[:event_id])
    # Asegurar que el evento pertenece al usuario actual
    @event = Current.user.events.find_by!(hash_id: event.hash_id) if event.hash_id
    @event ||= Current.user.events.find(event.id) if event.id
  end

  def set_theme
    @theme = @event.current_theme
  end

  def ensure_owner!
    redirect_to root_path, alert: "No tienes permisos para editar este evento." unless @event.user == Current.user
  end

  def theme_params
    params.require(:event_theme).permit(
      :name, :primary_color, :secondary_color, :background_color, :contrast_mode,
      :background_gradient, :floating_elements, :header_emoji,
      :title_template, :subtitle_template, :description_emojis,
      :accept_emoji, :decline_emoji, :accept_text, :decline_text,
      :success_message, :decline_message, :footer_message,
      :status_accepted_emoji, :status_declined_emoji, :status_pending_emoji,
      :date_icon, :location_icon, :gifts_icon,
      :button_style_class, :card_style_class
    )
  end
end
