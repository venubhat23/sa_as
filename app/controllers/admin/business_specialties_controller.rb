module Admin
  class BusinessSpecialtiesController < Admin::ApplicationController
    before_action :set_business_specialty, only: [:show, :edit, :update, :destroy]

    def index
      @business_specialties = BusinessSpecialty.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @business_specialty = BusinessSpecialty.new
    end

    def create
      @business_specialty = BusinessSpecialty.new(business_specialty_params)
      if @business_specialty.save
        redirect_to admin_business_specialty_path(@business_specialty), notice: "Business Specialty created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @business_specialty.update(business_specialty_params)
        redirect_to admin_business_specialty_path(@business_specialty), notice: "Business Specialty updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @business_specialty.destroy
      redirect_to admin_business_specialties_path, notice: "Business Specialty deleted successfully."
    end

    private

    def set_business_specialty
      @business_specialty = BusinessSpecialty.find(params[:id])
    end

    def business_specialty_params
      params.require(:business_specialty).permit(:name, :business_category_id, :description, :status)
    end
  end
end
