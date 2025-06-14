class BillingsController < ApplicationController
  before_action :set_billing, only: %i[ show edit update destroy ]
  before_action :set_data, only: %i[ show edit update destroy ]
  before_action :set_buildings_and_blocks_options, only: %i[new create]

  def index
    @billings = Billing.includes(contract: { apartment: { block: :building } })

    @grouped_billings = @billings.group_by do |billing|
      building = billing.contract.apartment.block.building
      block = billing.contract.apartment.block
      date = billing.billing_reference_date

      {
        building: building,
        block: block,
        year: date.year,
        month: date.month
      }
    end

    # Sort the groups by most recent creation date (latest first)
    @grouped_billings = @grouped_billings.sort_by do |group_key, billings|
      # Get the most recent created_at date from billings in this group
      -billings.map(&:created_at).max.to_i
    end.to_h
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: billing_name,
               template: "pdf/billing",
               formats: [ :html ]
      end
    end
  end

  def new
    @billing = Billing.new
    @buildings = Building.where(landlord_id: current_user.id)

    @buildings_blocks_options = @buildings.flat_map do |building|
      building.blocks.map do |block|
        [ "#{building.name} / #{block.name}", "#{building.id}_#{block.id}" ]
      end
    end

    @billing.charges.build(description: "Conta de Água (Bloco)")
    @billing.charges.build(description: "Conta de Energia (Comum)")
    @billing.charges.build(description: "Limpeza (Comum)")
    @billing.charges.build(description: "Gastos Extras (Comum)")
  end

  def edit
  end

  def create
    @billing = Billing.new(billing_params.except(:building_block_id))

    result = create_billing_service
    return handle_service_failure if result.nil?

    respond_to do |format|
      if result[:success]
        flash[:notice] = "#{result[:success_count]} cobrança(s) criada(s) com sucesso."
        format.html { redirect_to billings_path }
        format.json { render json: { message: flash[:notice] }, status: :created }
      else
        flash[:notice] = "#{result[:success_count]} cobrança(s) criada(s) com sucesso." if result[:sucess_count] != 0
        flash[:alert] = format_errors(result[:errors])
        format.html { redirect_to billings_path }
        format.json { render json: { errors: result[:errors] }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @billing.update(billing_params)
        format.html { redirect_to @billing, notice: "Cobrança atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @billing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @billing.destroy!

    respond_to do |format|
      format.html { redirect_to billings_path, status: :see_other, notice: "Cobrança deletada com sucesso." }
      format.json { head :no_content }
    end
  end

  private

    def set_billing
      @billing = Billing.find(params.expect(:id))
    end

    def set_buildings_and_blocks_options
      @buildings = Building.where(landlord_id: current_user.id)
      @buildings_blocks_options = @buildings.flat_map do |building|
        building.blocks.map do |block|
          [ "#{building.name} / #{block.name}", "#{building.id}_#{block.id}" ]
        end
      end
    end

    def billing_params
      params.expect(
        billing: [
          :building_block_id, :billing_reference_date, :rent_reference_date, :amount,
          charges_attributes: [ [ :id, :description, :amount  ] ]
        ]
      )
    end

    def billing_name
      "Cobranca_#{@billing_reference_start_date}_#{@tenant_name.gsub(" ", "-")}"
    end

    def set_data
      @apartment                          ||= @billing.contract.apartment
      @building                           ||= @apartment.block.building
      @address_street                     ||= @building.address_street
      @address_number                     ||= @building.address_number
      @address_district                   ||= @building.address_district
      @address_city                       ||= @building.address_city
      @charges                            ||= @billing.charges
      @tenant_name                        ||= @billing.contract.tenant.first_name + " " + @billing.contract.tenant.last_name
      @landlord_name                      ||= @billing.contract.tenant.landlord.first_name + " " + @billing.contract.tenant.landlord.last_name
      @billing_reference_start_date       ||= @billing.billing_reference_date.strftime("%d/%m/%y")
      @billing_reference_end_date         ||= @billing.billing_reference_end_date.strftime("%d/%m/%y")
      @billing_rent_reference_start_date  ||= @billing.rent_reference_date.strftime("%d/%m/%y")
      @billing_rent_reference_end_date    ||= @billing.rent_reference_end_date.strftime("%d/%m/%y")
      @rent_amount                        ||= @apartment.rent_amount
      @month_name                         ||= I18n.l(@billing_rent_reference_start_date.to_date, format: "%B")
    end

    def create_billing_service
      service = BillingCreationService.new(params.dig(:billing, :building_block_id), billing_params)
      service.call
    rescue => e
      Rails.logger.error "Billing creation failed: #{e.message}\n#{e.backtrace.join("\n")}"
      nil
    end

    def handle_service_failure
      flash[:error] = "Houve um erro ao processar o serviço de Cobranças. Por favor, tente novamente."
      render :new, status: :unprocessable_entity
    end

    def format_errors(errors)
      errors.map { |e| "#{e}" }.join("").html_safe
    end
end
