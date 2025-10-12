class PresupuestosController < ApplicationController
  before_action :set_event
  before_action :set_presupuesto, only: [ :show, :edit, :update, :destroy ]

  def index
    @presupuestos = @event.presupuestos.includes(:lineas)
  end

  def show
    @lineas = @presupuesto.lineas.order(:created_at)
  end

  def new
    @presupuesto = @event.presupuestos.build
  end

  def create
    @presupuesto = @event.presupuestos.build(presupuesto_params)

    if @presupuesto.save
      redirect_to event_presupuesto_path(@event, @presupuesto), notice: "Presupuesto creado exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @presupuesto.update(presupuesto_params)
      redirect_to event_presupuesto_path(@event, @presupuesto), notice: "Presupuesto actualizado exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @presupuesto.destroy
    redirect_to event_presupuestos_path(@event), notice: "Presupuesto eliminado exitosamente."
  end

  private

  def set_event
    # Si el parámetro parece ser un hash_id, buscar por hash_id
    if params[:event_id].match?(/\A[a-f0-9]{32}\z/)
      @event = Event.find_by!(hash_id: params[:event_id])
    else
      @event = Event.find(params[:event_id])
    end
  end

  def set_presupuesto
    @presupuesto = @event.presupuestos.find(params[:id])
  end

  def presupuesto_params
    params.require(:presupuesto).permit(:title, :description)
  end
end
