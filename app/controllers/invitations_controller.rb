class InvitationsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
  end

  def edit
  end

  def delete
  end
end
