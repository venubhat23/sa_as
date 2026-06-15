module Admin
  class NotificationsController < Admin::ApplicationController
    before_action :set_notification, only: [:show, :edit, :update, :destroy]

    def index
      @notifications = Notification.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @notification = Notification.new
    end

    def create
      @notification = Notification.new(notification_params)
      if @notification.save
        redirect_to admin_notification_path(@notification), notice: "Notification created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @notification.update(notification_params)
        redirect_to admin_notification_path(@notification), notice: "Notification updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @notification.destroy
      redirect_to admin_notifications_path, notice: "Notification deleted successfully."
    end

    private

    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:user_id, :title, :body, :notification_type, :is_read, :sent_at)
    end
  end
end
