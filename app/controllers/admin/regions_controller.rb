module Admin
  class RegionsController < Admin::ApplicationController
    before_action :set_region, only: [:show, :edit, :update, :destroy]

    def index
      @regions = Region.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @region = Region.new
    end

    def create
      @region = Region.new(region_params)
      if @region.save
        redirect_to admin_region_path(@region), notice: "Region created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @region.update(region_params)
        redirect_to admin_region_path(@region), notice: "Region updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @region.destroy
      redirect_to admin_regions_path, notice: "Region deleted successfully."
    end

    private

    def set_region
      @region = Region.find(params[:id])
    end

    def region_params
      params.require(:region).permit(:name, :code, :description, :status)
    end
  end
end
