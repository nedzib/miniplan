class EventsController < ApplicationController
  include EventFinder

  before_action :set_user
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = @user.events.order(start_time: :asc)
  end

  def show
  end

  def new
    @event = @user.events.build
  end

  def create
    @event = @user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully."
  end

  private

  def set_user
    @user = Current.user
  end

  def set_event
    event = find_event_by_param(params[:id])
    # Asegurar que el evento pertenece al usuario actual
    @event = @user.events.find_by!(hash_id: event.hash_id) if event.hash_id
    @event ||= @user.events.find(event.id) if event.id
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :start_time, :end_time, :rsvp_deadline, :map_url)
  end
end
