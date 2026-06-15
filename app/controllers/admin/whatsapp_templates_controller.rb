module Admin
  class WhatsappTemplatesController < Admin::ApplicationController
    before_action :set_whatsapp_template, only: [:show, :edit, :update, :destroy]

    def index
      @whatsapp_templates = WhatsappTemplate.order(created_at: :desc).page(params[:page]).per(25)
    end

    def show
    end

    def new
      @whatsapp_template = WhatsappTemplate.new
    end

    def create
      @whatsapp_template = WhatsappTemplate.new(whatsapp_template_params)
      if @whatsapp_template.save
        redirect_to admin_whatsapp_template_path(@whatsapp_template), notice: "Whatsapp Template created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @whatsapp_template.update(whatsapp_template_params)
        redirect_to admin_whatsapp_template_path(@whatsapp_template), notice: "Whatsapp Template updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @whatsapp_template.destroy
      redirect_to admin_whatsapp_templates_path, notice: "Whatsapp Template deleted successfully."
    end

    private

    def set_whatsapp_template
      @whatsapp_template = WhatsappTemplate.find(params[:id])
    end

    def whatsapp_template_params
      params.require(:whatsapp_template).permit(:name, :body, :template_type, :status)
    end
  end
end
