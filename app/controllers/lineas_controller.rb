class LineasController < ApplicationController
  before_action :set_event_and_presupuesto
  before_action :set_linea, only: [ :edit, :update, :destroy ]

  def index
    @lineas = @presupuesto.lineas.order(:created_at)
  end

  def new
    @linea = @presupuesto.lineas.build
  end

  def create
    @linea = @presupuesto.lineas.build(linea_params)

    if @linea.save
      redirect_to event_presupuesto_path(@event, @presupuesto), notice: "L\u00EDnea agregada exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @linea.update(linea_params)
      redirect_to event_presupuesto_path(@event, @presupuesto), notice: "L\u00EDnea actualizada exitosamente."
    else
      render :edit
    end
  end

  def destroy
    @linea.destroy
    redirect_to event_presupuesto_path(@event, @presupuesto), notice: "L\u00EDnea eliminada exitosamente."
  end

  private

  def set_event_and_presupuesto
    @event = Event.find(params[:event_id])
    @presupuesto = @event.presupuestos.find(params[:presupuesto_id])
  end

  def set_linea
    @linea = @presupuesto.lineas.find(params[:id])
  end

  def linea_params
    params.require(:linea).permit(:concepto, :valor, :por_persona)
  end
end
