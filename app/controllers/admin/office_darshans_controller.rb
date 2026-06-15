module Admin
  class OfficeDarshansController < Admin::ApplicationController
    before_action :set_office_darshan, only: [:show, :edit, :update, :destroy]

    def index
      @office_darshans = OfficeDarshan.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @office_darshan = OfficeDarshan.new
    end

    def create
      @office_darshan = OfficeDarshan.new(office_darshan_params)
      if @office_darshan.save
        redirect_to admin_office_darshan_path(@office_darshan), notice: "Office Darshan created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @office_darshan.update(office_darshan_params)
        redirect_to admin_office_darshan_path(@office_darshan), notice: "Office Darshan updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @office_darshan.destroy
      redirect_to admin_office_darshans_path, notice: "Office Darshan deleted successfully."
    end

    private

    def set_office_darshan
      @office_darshan = OfficeDarshan.find(params[:id])
    end

    def office_darshan_params
      params.require(:office_darshan).permit(:host_member_id, :visit_date, :purpose, :feedback, :status)
    end
  end
end
