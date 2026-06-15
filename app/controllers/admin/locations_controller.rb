module Admin
  class LocationsController < Admin::ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    def index
      @locations = Location.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @location = Location.new
    end

    def create
      @location = Location.new(location_params)
      if @location.save
        redirect_to admin_location_path(@location), notice: "Location created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @location.update(location_params)
        redirect_to admin_location_path(@location), notice: "Location updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @location.destroy
      redirect_to admin_locations_path, notice: "Location deleted successfully."
    end

    private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :address, :city, :state, :pincode, :region_id, :chapter_id)
    end
  end
end
