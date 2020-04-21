class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    discount = @merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "A new discount has created."
      redirect_to "/merchant/discounts"
    else
      flash[:error] = "Unable to create discount: #{discount.errors.full_messages.to_sentence}."
      render :new
    end
  end

  private

  def discount_params
    params.permit(:percent,:amount)
  end
end
