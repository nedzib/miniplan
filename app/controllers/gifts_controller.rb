class GiftsController < ApplicationController
  # Permitir acceso sin autenticación para las rutas públicas
  allow_unauthenticated_access only: [ :public_index, :public_create ]

  before_action :set_event
  before_action :set_gift, only: [ :show, :edit, :update, :destroy ]

  def index
    @gifts = @event.gifts.recent.includes(:event)
    @new_gift = @event.gifts.build
  end

  def show
    # Mostrar detalles de un regalo específico
  end

  def create
    @gift = @event.gifts.build(gift_params)
    @gift.purchased_by = "Anónimo" if @gift.purchased_by.blank?

    respond_to do |format|
      if @gift.save
        format.html { redirect_to event_gifts_path(@event), notice: "¡Regalo registrado exitosamente! 🎁" }
        format.json { render json: { success: true, message: "Regalo registrado exitosamente", gift: @gift } }
      else
        format.html {
          @gifts = @event.gifts.recent.includes(:event)
          @new_gift = @gift
          render :index
        }
        format.json { render json: { success: false, errors: @gift.errors.full_messages } }
      end
    end
  end

  def edit
    # Formulario de edición
  end

  def update
    respond_to do |format|
      if @gift.update(gift_params)
        format.html { redirect_to event_gifts_path(@event), notice: "¡Regalo actualizado exitosamente! ✏️" }
        format.json { render json: { success: true, message: "Regalo actualizado exitosamente", gift: @gift } }
      else
        format.html { render :edit }
        format.json { render json: { success: false, errors: @gift.errors.full_messages } }
      end
    end
  end

  def destroy
    @gift.destroy!
    respond_to do |format|
      format.html { redirect_to event_gifts_path(@event), notice: "Regalo eliminado exitosamente 🗑️" }
      format.json { render json: { success: true, message: "Regalo eliminado exitosamente" } }
    end
  end

  # Rutas públicas usando hash_id del evento
  def public_index
    @gifts = @event.gifts.recent.includes(:event)
    @new_gift = @event.gifts.build
    render :public_index
  end

  def public_create
    @gift = @event.gifts.build(gift_params)
    @gift.purchased_by = "Anónimo" if @gift.purchased_by.blank?

    respond_to do |format|
      if @gift.save
        format.html { redirect_to public_gifts_path(@event.hash_id), notice: "¡Regalo registrado exitosamente! 🎁" }
        format.json { render json: { success: true, message: "Regalo registrado exitosamente", gift: @gift } }
      else
        format.html {
          @gifts = @event.gifts.recent.includes(:event)
          @new_gift = @gift
          render :public_index
        }
        format.json { render json: { success: false, errors: @gift.errors.full_messages } }
      end
    end
  end

  private

  def set_event
    if params[:event_id]
      # Ruta administrativa usando event_id
      if params[:event_id].match?(/\A[a-f0-9]{32}\z/)
        @event = Event.find_by!(hash_id: params[:event_id])
      else
        @event = Event.find(params[:event_id])
      end
    elsif params[:event_hash_id]
      # Ruta pública usando hash_id
      @event = Event.find_by!(hash_id: params[:event_hash_id])
    else
      redirect_to root_path, alert: "Evento no encontrado"
    end
  end

  def set_gift
    @gift = @event.gifts.find(params[:id])
  end

  def gift_params
    params.require(:gift).permit(:name, :purchased_by)
  end
end
