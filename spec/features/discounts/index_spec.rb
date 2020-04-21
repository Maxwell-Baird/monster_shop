require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @merchant_user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
      @dog_shop.add_employee(@merchant_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'I can see a list of discounts used by merchant' do
      discount1 = @dog_shop.discounts.create(percent: 5, amount: 20)
      discount2 = @dog_shop.discounts.create(percent: 15, amount: 60)
      discount3 = @dog_shop.discounts.create(percent: 50, amount: 200)

      visit '/merchant'

      expect(page).to have_link("Discounts")

      click_on "Discounts"

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("#{discount1.percent}% discount on #{discount1.amount} or more items.")
      expect(page).to have_content("#{discount2.percent}% discount on #{discount2.amount} or more items.")
      expect(page).to have_content("#{discount3.percent}% discount on #{discount3.amount} or more items.")
    end
    it 'I can see a link to create a new discount' do

      visit '/merchant'

      expect(page).to have_link("Discounts")

      click_on "Discounts"
      expect(page).to have_link("New Discount")
      
      click_on "New Discount"
      expect(current_path).to eq("/merchant/discounts/new")
    end
  end
end
