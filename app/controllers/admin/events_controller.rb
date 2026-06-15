module Admin
  class EventsController < Admin::ApplicationController
    before_action :set_event, only: [:show, :edit, :update, :destroy]

    def index
      @events = Event.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        redirect_to admin_event_path(@event), notice: "Event created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @event.update(event_params)
        redirect_to admin_event_path(@event), notice: "Event updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      redirect_to admin_events_path, notice: "Event deleted successfully."
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :event_type, :start_date, :end_date, :venue, :description, :capacity, :registration_fee, :status)
    end
  end
end
