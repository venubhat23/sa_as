module Admin
  class FeeCollectionsController < Admin::ApplicationController
    before_action :set_fee_collection, only: [:show, :edit, :update, :destroy]

    def index
      @fee_collections = FeeCollection.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @fee_collection = FeeCollection.new
    end

    def create
      @fee_collection = FeeCollection.new(fee_collection_params)
      if @fee_collection.save
        redirect_to admin_fee_collection_path(@fee_collection), notice: "Fee Collection created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @fee_collection.update(fee_collection_params)
        redirect_to admin_fee_collection_path(@fee_collection), notice: "Fee Collection updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @fee_collection.destroy
      redirect_to admin_fee_collections_path, notice: "Fee Collection deleted successfully."
    end

    private

    def set_fee_collection
      @fee_collection = FeeCollection.find(params[:id])
    end

    def fee_collection_params
      params.require(:fee_collection).permit(:member_id, :renewal_id, :amount, :payment_mode, :payment_date, :receipt_number, :notes, :status)
    end
  end
end
