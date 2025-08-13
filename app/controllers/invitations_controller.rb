class InvitationsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:invitation][:event_id])
    @invitation = @event.invitations.build(invitation_params)

    if @invitation.save
      redirect_to invitations_index_path(event_id: @event.id), notice: "Invitation was successfully created."
    else
      redirect_to invitations_index_path(event_id: @event.id), alert: @invitation.errors.full_messages.join(", ")
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @invitation = Invitation.find(params[:invitation_id])
  end

  def update
    @invitation = Invitation.find(params[:id])
    @event = @invitation.event

    if @invitation.update(invitation_params)
      redirect_to invitations_index_path(event_id: @event.id), notice: "Invitation was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @invitation = Invitation.find(params[:invitation_id])
    @event = @invitation.event
    @invitation.destroy
    redirect_to invitations_index_path(event_id: @event.id), notice: "Invitation was successfully deleted."
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :phone, :status, :event_id)
  end
end
