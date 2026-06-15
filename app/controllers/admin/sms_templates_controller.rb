module Admin
  class SmsTemplatesController < Admin::ApplicationController
    before_action :set_sms_template, only: [:show, :edit, :update, :destroy]

    def index
      @sms_templates = SmsTemplate.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @sms_template = SmsTemplate.new
    end

    def create
      @sms_template = SmsTemplate.new(sms_template_params)
      if @sms_template.save
        redirect_to admin_sms_template_path(@sms_template), notice: "Sms Template created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @sms_template.update(sms_template_params)
        redirect_to admin_sms_template_path(@sms_template), notice: "Sms Template updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sms_template.destroy
      redirect_to admin_sms_templates_path, notice: "Sms Template deleted successfully."
    end

    private

    def set_sms_template
      @sms_template = SmsTemplate.find(params[:id])
    end

    def sms_template_params
      params.require(:sms_template).permit(:name, :body, :template_type, :status)
    end
  end
end
