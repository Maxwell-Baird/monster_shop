class Cart
  attr_reader :contents, :discounts

  def initialize(contents)
    @contents = contents
    @discounts = []
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def add_quantity(item)
    @contents[item] += 1
    check_discounts(item)
  end

  def subtract_quantity(item)
    @contents[item] -= 1
  end

  def quantity_zero?(item)
    @contents[item].zero?
  end

  def limit_reached?(item)
    @contents[item] == Item.find(item).inventory
  end

  def check_discounts(item)
    item = Item.find(item)
    merchant = Merchant.find(item.merchant_id)
    discounts = merchant.discounts.order(percent: :desc)
    amount_buying = @contents[item]
    binding.pry
  end
end
