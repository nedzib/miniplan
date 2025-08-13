class EventsController < ApplicationController
  before_action :set_user
  def index
  end

  def show
  end

  def set_user
    @user = Current.user
  end
end
