class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
  end
end
