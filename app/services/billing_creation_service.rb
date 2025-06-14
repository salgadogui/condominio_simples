class BillingCreationService
  def initialize(building_block_id, billing_params)
    @building_id, @block_id = building_block_id.split("_")
    @billing_params = billing_params.except(:building_block_id)
    @errors = []
    @success_count = 0
  end

  def call
    ActiveRecord::Base.transaction do
      fetch_resources
      process_apartments
    end

    { success: @errors.empty?, errors: @errors, success_count: @success_count }
  end

  private

  def fetch_resources
    @building = Building.find(@building_id)
    @block = Block.find(@block_id)
    @apartments = @block.apartments
    @total_apartments = @building.blocks.sum { |b| b.apartments.count }
  end

  def process_apartments
    @apartments.each do |apartment|
      contract = apartment.contracts.active.first

      if contract.nil?
        @errors << "Cobrança não criada para o apartamento #{apartment.number}. Não há um contrato ativo."
        next
      end

      charges = build_charges(@billing_params[:charges_attributes], apartment)
      new_billing = create_billing(contract, apartment, charges)

      unless new_billing.save
        @errors << "Erro ao criar cobrança para o apartamento #{apartment.number}: #{new_billing.errors.full_messages.join(', ')}"
        raise ActiveRecord::Rollback
      end

      @success_count += 1
    end
  end

  def build_charges(charges_params, apartment)
    charges_params.values.map do |charge_params|
      charge_type, amount = case charge_params[:description]
                            when "Conta de Água (Bloco)"
                              # NOTE: check if the .to_f method id rounding the value to 1 decimal place
                              [ "block", charge_params[:amount].to_f / @block.apartments.count ]
                            when "Conta de Energia (Comum)", "Limpeza (Comum)", "Gastos Extras (Comum)"
                              [ "common", charge_params[:amount].to_f / @total_apartments ]
                            else
                              [ nil, charge_params[:amount].to_f ]
                            end # rubocop:disable Layout/EndAlignment

      { description: charge_params[:description], amount: amount, charge_type: charge_type }
    end
  end

  def create_billing(contract, apartment, charges)
    Billing.new(
      contract_id: contract.id,
      billing_reference_date: "#{@billing_params[:billing_reference_date]}-#{contract.start_date.day}",
      rent_reference_date: "#{@billing_params[:rent_reference_date]}-#{contract.start_date.day}",
      amount: charges.sum { |c| c[:amount] } + apartment.rent_amount,
      charges_attributes: charges
    )
  end
end
