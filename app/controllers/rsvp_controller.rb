class RsvpController < ApplicationController
  def confirm
    @invitation = Invitation.find_by!(hash_id: params[:hash_id])
    @event = @invitation.event
  end

  def update
    # Try to find by hash_id first (new secure method), fallback to invitation_id (old method)
    @invitation = if params[:hash_id]
                    Invitation.find_by!(hash_id: params[:hash_id])
    else
                    Invitation.find(params[:invitation_id])
    end

    if @invitation.update(status: params[:status])
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
