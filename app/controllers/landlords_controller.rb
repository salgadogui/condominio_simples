class LandlordsController < ApplicationController
  before_action :ensure_landlord
  before_action :set_landlord
  before_action :set_tenants

  def index
  end

  private

  def ensure_landlord
    redirect_to root_url unless current_user
  end

  def set_landlord
    @landlord = current_user
  end

  def set_tenants
    @tenants = @landlord.tenants
  end
end
