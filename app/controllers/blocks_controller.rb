class BlocksController < ApplicationController
  before_action :set_block, only: %i[ show edit update destroy ]

  def index
    @blocks = Block.all
  end

  def show
  end

  def new
    @block = Block.new(building_id: params[:building_id])
  end

  def edit
  end

  def create
    @block = Block.new(block_params)

    respond_to do |format|
      if @block.save
        format.html { redirect_to building_path(@block.building), notice: "Bloco criado com sucesso." }
        format.json { render :show, status: :created, location: @block }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @block.update(block_params)
        format.html { redirect_to @block, notice: "Bloco atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @block }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @block.destroy!

    respond_to do |format|
      format.html { redirect_to building_path(@block.building), status: :see_other, notice: "Bloco deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    def set_block
      @block = Block.find(params.expect(:id))
    end

    def block_params
      params.expect(block: [ :building_id, :name ])
    end
end
