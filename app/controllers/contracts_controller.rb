class ContractsController < ApplicationController
  before_action :set_contract, only: %i[ show edit update destroy ]
  before_action :set_buildings
  before_action :set_apartments
  before_action :set_tenants

  def index
    @contracts = Contract.all
  end

  def show
  end

  def new
    @contract = Contract.new
  end

  def edit
  end

  def create
    @contract = Contract.new(contract_params.except(:building_id))

    respond_to do |format|
      if @contract.save
        format.html { redirect_to contracts_path, notice: "Contrado criado com sucesso." }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @contract.update(contract_params.except(:building_id))
        format.html { redirect_to @contract, notice: "Contrato atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract.destroy!

    respond_to do |format|
      format.html { redirect_to contracts_path, status: :see_other, notice: "Contrado deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  def apartments
    building = Building.includes(:apartments).find_by(id: params[:building_id])

    apartments = building ? building.apartments.select(:id, :number) : []

    render json: apartments
  end

  private
    def set_contract
      @contract = Contract.find(params.expect(:id))
    end

    def set_apartments
      @apartments = Apartment.includes(block: :building)
                             .where(blocks: { building_id: current_user.building_ids })
                            &.where(blocks: { building_id: params.dig(:contract, 0) })
    end

    def set_tenants
      @tenants = current_user.tenants
    end

    def set_buildings
      @buildings = current_user.buildings
    end

    def contract_params
      params.expect(contract: [ :building_id, :apartment_id, :landlord_id, :tenant_id, :start_date, :end_date, :status ])
    end
end
