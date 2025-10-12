class RsvpController < ApplicationController
  allow_unauthenticated_access
  def confirm
    @invitation = Invitation.find_by!(hash_id: params[:hash_id])
    @event = @invitation.event

    # Cargar miembros del grupo familiar si existe
    if @invitation.family_group
      @family_members = @invitation.family_group.invitations.where.not(id: @invitation.id)
    else
      @family_members = []
    end
  end

  def family_confirm
    @family_group = FamilyGroup.find_by!(hash_id: params[:hash_id])
    @event = @family_group.event
    @invitations = @family_group.invitations
  end

  def family_update
    @family_group = FamilyGroup.find_by!(hash_id: params[:hash_id])
    @event = @family_group.event

    # Verificar si el deadline de RSVP ha pasado
    if @event.rsvp_deadline_passed?
      render json: {
        success: false,
        error: "RSVP deadline has passed",
        message: "Las confirmaciones para este evento ya han cerrado."
      }, status: :forbidden
      return
    end

    # Actualizar las invitaciones del grupo familiar
    success_count = 0
    error_messages = []

    if params[:family_members].present?
      params[:family_members].each do |member_id, member_data|
        invitation = @family_group.invitations.find_by(id: member_id)
        if invitation && member_data[:status].present?
          if invitation.update(status: member_data[:status])
            success_count += 1
          else
            error_messages << "Error actualizando #{invitation.name}: #{invitation.errors.full_messages.join(', ')}"
          end
        end
      end
    end

    if success_count > 0
      message = success_count == 1 ?
        "Confirmación actualizada con amor y paz 🌻" :
        "#{success_count} confirmaciones actualizadas con buenas vibras ✌️"

      render json: {
        success: true,
        message: message
      }
    else
      error_message = error_messages.any? ?
        error_messages.join(". ") :
        "No se pudo actualizar ninguna confirmación"

      render json: {
        success: false,
        message: error_message
      }, status: :unprocessable_entity
    end
  end

  def update
    # Try to find by hash_id first (new secure method), fallback to invitation_id (old method)
    @invitation = if params[:hash_id]
                    Invitation.find_by!(hash_id: params[:hash_id])
    else
                    Invitation.find(params[:invitation_id])
    end

    @event = @invitation.event

    # Verificar si el deadline de RSVP ha pasado
    if @event.rsvp_deadline_passed?
      render json: {
        success: false,
        error: "RSVP deadline has passed",
        message: "Las confirmaciones para este evento ya han cerrado."
      }, status: :forbidden
      return
    end

    # Actualizar la invitación principal
    if @invitation.update(status: params[:status])

      # Si se envían confirmaciones para miembros del grupo familiar
      if params[:family_members].present?
        params[:family_members].each do |member_id, member_status|
          if member_status == "1" # checkbox marcado
            family_invitation = Invitation.find(member_id)
            family_invitation.update(status: params[:status]) if family_invitation.family_group == @invitation.family_group
          end
        end
      end

      render json: { success: true, status: @invitation.status }
    else
      render json: { success: false, errors: @invitation.errors }, status: :unprocessable_entity
    end
  end

  def partial
    partial_name = params[:name]

    case partial_name
    when "accepted_response"
      render partial: "accepted_response", layout: false
    when "declined_response"
      render partial: "declined_response", layout: false
    else
      render plain: "Partial not found", status: :not_found
    end
  end
end
