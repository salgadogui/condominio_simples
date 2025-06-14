class ApartmentsController < ApplicationController
  before_action :set_apartment, only: %i[ show edit update destroy ]
  before_action :set_building, only: %i[ new create ]

  def index
    @apartments = Apartment.all
  end

  def show
  end

  def new
    @apartment = Apartment.new
    @blocks = @building.blocks
  end

  def edit
    @blocks = @apartment.block.building.blocks
  end

  def create
    @apartment = Apartment.new(apartment_params)
    @blocks = @building.blocks

    respond_to do |format|
      if @apartment.save
        building = @apartment.block&.building
        if building
          format.html { redirect_to building_path(building), notice: "Apartamento/sala criado com sucesso." }
        else
          format.html { redirect_to apartments_path, alert: "Apartamento criado, mas sem vínculo com um imóvel." }
        end
        format.json { render :show, status: :created, location: @apartment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @apartment.update(apartment_params)
        format.html { redirect_to @apartment, notice: "Apartamento/sala atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @apartment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @apartment.destroy!

    respond_to do |format|
      format.html { redirect_to building_path(@apartment.block.building), status: :see_other, notice: "Apartamento/sala deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    def set_building
      @building = Building.find(params[:building_id] || params.dig(:apartment, :building_id))
    end

    def set_apartment
      @apartment = Apartment.find(params.expect(:id))
    end

    def apartment_params
      params.expect(apartment: [ :block_id, :number, :rent_amount ])
    end
end
