class ChargesController < ApplicationController
  before_action :set_charge, only: %i[ show edit update destroy ]

  def index
    @charges = Charge.all
  end

  def show
  end

  def new
    @charge = Charge.new
  end

  def edit
  end

  def create
    @charge = Charge.new(charge_params)

    respond_to do |format|
      if @charge.save
        format.html { redirect_to @charge, notice: "Encargo criado com sucesso." }
        format.json { render :show, status: :created, location: @charge }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @charge.update(charge_params)
        format.html { redirect_to @charge, notice: "Encargo atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @charge }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @charge.destroy!

    respond_to do |format|
      format.html { redirect_to charges_path, status: :see_other, notice: "Encargo deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    def set_charge
      @charge = Charge.find(params.expect(:id))
    end

    def charge_params
      params.expect(charge: [ :billing_id, :description, :amount, :type ])
    end
end
