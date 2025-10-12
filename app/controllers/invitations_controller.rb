class InvitationsController < ApplicationController
  before_action :set_event

  def index
    @family_groups = @event.family_groups
  end

  def create
    @invitation = @event.invitations.build(invitation_params)

    if @invitation.save
      # Redirección con parámetros limpios para evitar problemas con el formulario
      redirect_to event_invitations_path(@event, success: "created"), notice: "Invitation was successfully created."
    else
      @family_groups = @event.family_groups
      flash.now[:alert] = @invitation.errors.full_messages.join(", ")
      render :index, status: :unprocessable_entity
    end
  end

  def edit
    @invitation = Invitation.find_by!(hash_id: params[:id])
    @event = @invitation.event
  end

  def update
    @invitation = Invitation.find_by!(hash_id: params[:id])
    @event = @invitation.event

    if @invitation.update(invitation_params)
      # Si viene de family_groups, redirigir allí
      if request.referer&.include?("family_groups")
        redirect_to event_family_groups_path(@event), notice: "Invitación actualizada exitosamente."
      else
        redirect_to event_invitations_path(@event), notice: "Invitation was successfully updated."
      end
    else
      render :edit
    end
  end

  def destroy
    @invitation = Invitation.find_by!(hash_id: params[:id])
    @event = @invitation.event
    @invitation.destroy
    redirect_to event_invitations_path(@event), notice: "Invitation was successfully deleted."
  end

  def reset_all
    @event.invitations.update_all(status: :pending)
    redirect_to event_invitations_path(@event), notice: "Todas las invitaciones han sido reseteadas a estado pendiente."
  end

  private

  def set_event
    @event = Event.find(params[:event_id]) if params[:event_id]
  end

  def invitation_params
    params.require(:invitation).permit(:name, :email, :phone, :status, :event_id, :family_group_id)
  end
end
