module Admin
  class BusinessCategoriesController < Admin::ApplicationController
    before_action :set_business_category, only: [:show, :edit, :update, :destroy]

    def index
      @business_categories = BusinessCategory.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @business_category = BusinessCategory.new
    end

    def create
      @business_category = BusinessCategory.new(business_category_params)
      if @business_category.save
        redirect_to admin_business_category_path(@business_category), notice: "Business Category created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @business_category.update(business_category_params)
        redirect_to admin_business_category_path(@business_category), notice: "Business Category updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @business_category.destroy
      redirect_to admin_business_categories_path, notice: "Business Category deleted successfully."
    end

    private

    def set_business_category
      @business_category = BusinessCategory.find(params[:id])
    end

    def business_category_params
      params.require(:business_category).permit(:name, :description, :status)
    end
  end
end
