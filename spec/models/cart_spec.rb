require 'rails_helper'

RSpec.describe Cart do

  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 2)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @seat = @mike.items.create(name: "Bike Seat", description: "Squishy tushy.", price: 14, image: "https://www.sefiles.net/images/library/zoom/planet-bike-little-a.r.s-bike-seat-231296-1-19-9.jpg", inventory: 17)
    @cart = Cart.new(Hash.new(0))
    @mike.discounts.create(percent: 10, amount: 3)
  end

  describe "instance methods" do
    it "#add_item(item) adds an item to the cart" do
      expect(@cart.contents[@paper.id]).to eq(0)
      @cart.add_item(@paper.id)
      expect(@cart.contents[@paper.id]).to eq(1)
    end

    it "#total_items returns total items in cart" do
      @cart.add_item(@paper.id)
      @cart.add_item(@paper.id)
      @cart.add_item(@pencil.id)

      expect(@cart.total_items).to eq(3)
    end

    it "#items returns the quantity of each item" do
      @cart.add_item(@paper.id)
      @cart.add_item(@pencil.id)
      @cart.add_item(@paper.id)

      expect(@cart.items).to eq({@paper => 2, @pencil => 1})
    end

    it "#subtotal(item) returns the subtotal of an item's price * quantity" do
      @cart.add_item(@paper.id.to_s) # Why doesn't this have to be a string?
      expect(@cart.subtotal(@paper)).to eq(20)
      @cart.add_item(@paper.id.to_s)
      expect(@cart.subtotal(@paper)).to eq(40)
    end

    it "#total returns to total cost of everything in cart" do
      @cart.add_item(@paper.id)
      @cart.add_item(@pencil.id)
      expect(@cart.total).to eq(22)
      @cart.add_item(@pencil.id)
      expect(@cart.total).to eq(24)
    end

    it "#add_quantity(item) adds 1 to an existing cart item" do
      @cart.add_item(@paper)
      expect(@cart.contents[@paper]).to eq(1)
      @cart.add_quantity(@paper)
      expect(@cart.contents[@paper]).to eq(2)
    end

    it "#subtract_quantity(item) subtracts 1 to an existing cart item" do
      @cart.add_item(@paper)
      @cart.add_item(@paper)
      expect(@cart.contents[@paper]).to eq(2)
      @cart.subtract_quantity(@paper)
      expect(@cart.contents[@paper]).to eq(1)
    end

    it "#quantity_zero?(item) returns true if the quantity of an item in cart is 0" do
      @cart.add_item(@paper)
      expect(@cart.quantity_zero?(@paper)).to be_falsey
      @cart.subtract_quantity(@paper)
      expect(@cart.quantity_zero?(@paper)).to be_truthy
    end

    it "#limit_reached?(item) returns true if quantity in cart matches the item stock" do
      @cart.add_item(@paper.id.to_s)
      expect(@cart.limit_reached?(@paper.id.to_s)).to be_falsey
      @cart.add_item(@paper.id.to_s)
      expect(@cart.limit_reached?(@paper.id.to_s)).to be_truthy
    end

    it "#can find if a discount has been applied" do
      @cart.add_item(@seat.id.to_s)
      @cart.add_item(@seat.id.to_s)
      @cart.add_item(@seat.id.to_s)
      expect(@cart.check_discount(@seat.id)).to eq(10)
      @cart.subtract_quantity(@seat.id.to_s)
      expect(@cart.check_discount(@seat.id)).to eq(0)
    end

    it "#returns a percent in float" do
      @cart.add_item(@seat.id.to_s)
      @cart.add_item(@seat.id.to_s)
      @cart.add_item(@seat.id.to_s)
      expect(@cart.discount(@seat.id)).to eq(0.1)
      @cart.subtract_quantity(@seat.id.to_s)
      expect(@cart.check_discount(@seat.id)).to eq(0)
    end
  end
end
