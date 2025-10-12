class FamilyGroupsController < ApplicationController
  before_action :set_event
  before_action :set_family_group, only: [ :destroy ]

  def index
    @family_groups = @event.family_groups.includes(:invitations)
    @invitations_without_group = @event.invitations.where(family_group: nil)
    @new_family_group = @event.family_groups.build
  end

  def create
    @family_group = @event.family_groups.build(family_group_params)

    if @family_group.save
      redirect_to event_family_groups_path(@event), notice: "Grupo familiar creado exitosamente."
    else
      @family_groups = @event.family_groups.includes(:invitations)
      @invitations_without_group = @event.invitations.where(family_group: nil)
      @new_family_group = @family_group
      render :index
    end
  end

  def destroy
    Rails.logger.info "Attempting to destroy family group: #{@family_group.name} (ID: #{@family_group.id})"

    if @family_group.destroy
      Rails.logger.info "Family group destroyed successfully"
      redirect_to event_family_groups_path(@event), notice: "Grupo familiar eliminado exitosamente."
    else
      Rails.logger.error "Failed to destroy family group: #{@family_group.errors.full_messages.join(', ')}"
      redirect_to event_family_groups_path(@event), alert: "Error al eliminar el grupo familiar."
    end
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

  def set_family_group
    @family_group = @event.family_groups.find_by!(hash_id: params[:id])
  end

  def family_group_params
    params.require(:family_group).permit(:name)
  end
end
