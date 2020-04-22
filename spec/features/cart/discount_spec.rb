require 'rails_helper'

describe "cart page" do

  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 13)
    @pencil = @bike_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    @discount1 = @mike.discounts.create(percent: 10, amount: 5)
  end

  it "a discount is applied" do
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"

    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"

    within "#cart-item-#{@paper.id}" do
      within "##{@paper.id}-quantity" do
        click_on("+1")
        expect(page).to have_content("2")
        click_on("+1")
        expect(page).to have_content("3")
        click_on("+1")
        expect(page).to have_content("4")
        click_on("+1")
        expect(page).to have_content("5")
      end
      expect(page).to have_content("$90.00")
    end
    expect(page).to have_content("Total: $92")
  end

  it "a discount is removed" do
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"

    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"

    within "#cart-item-#{@paper.id}" do
      within "##{@paper.id}-quantity" do
        click_on("+1")
        expect(page).to have_content("2")
        click_on("+1")
        expect(page).to have_content("3")
        click_on("-1")
        expect(page).to have_content("2")
      end
      expect(page).to have_content("$40.00")
    end
    expect(page).to have_content("Total: $42")
  end

  it "the higher discount is chosen" do
    discount2 = @mike.discounts.create(percent: 15, amount: 5)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"

    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit "/cart"

    within "#cart-item-#{@paper.id}" do
      within "##{@paper.id}-quantity" do
        click_on("+1")
        expect(page).to have_content("2")
        click_on("+1")
        expect(page).to have_content("3")
        click_on("+1")
        expect(page).to have_content("4")
        click_on("+1")
        expect(page).to have_content("5")
      end
      expect(page).to have_content("$85.00")
    end
    expect(page).to have_content("Total: $87")
  end
end
