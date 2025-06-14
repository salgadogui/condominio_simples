class BuildingsController < ApplicationController
  before_action :set_building, only: %i[ show edit update destroy ]

  def index
    @buildings = Building.all
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @building = Building.new
  end

  def edit
  end

  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        format.html { redirect_to buildings_path, notice: "Imóvel criado com sucesso." }
        format.json { render :show, status: :created, location: @building }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @building.update(building_params)
        format.html { redirect_to buildings_path, notice: "Imóvel atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @building }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @building.destroy!

    respond_to do |format|
      format.html { redirect_to buildings_path, status: :see_other, notice: "Imóvel deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    def set_building
      @building = Building.find(params.expect(:id))
    end

    def building_params
      params.expect(building: [ :landlord_id, :name, :address_street, :address_number, :address_district, :address_city, :address_state, :cep ])
    end
end
