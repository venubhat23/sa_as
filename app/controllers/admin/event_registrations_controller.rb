module Admin
  class EventRegistrationsController < Admin::ApplicationController
    before_action :set_event

    def index
      @registrations = @event.event_registrations.includes(:member)
      @members = Member.all
    end

    def create
      @registration = @event.event_registrations.new(registration_params)
      @registration.save
      redirect_to admin_event_path(@event), notice: "Registration added."
    end

    def update
      @registration = @event.event_registrations.find(params[:id])
      @registration.update(registration_params)
      redirect_to admin_event_path(@event), notice: "Registration updated."
    end

    def destroy
      @event.event_registrations.find(params[:id]).destroy
      redirect_to admin_event_path(@event), notice: "Registration removed."
    end

    private

    def set_event
      @event = Event.find(params[:event_id])
    end

    def registration_params
      params.require(:event_registration).permit(:member_id, :registration_date, :payment_status, :attendance_status)
    end
  end
end
