require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @merchant_user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
      @dog_shop.add_employee(@merchant_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
    end

    it 'I can delete a discount' do
      discount = @dog_shop.discounts.create(percent: 5, amount: 20)

      visit '/merchant/discounts'
      expect(page).to have_content("#{discount.percent}% discount on #{discount.amount} or more items.")
      expect(page).to have_link("Delete discount")
      click_on "Delete discount"
      expect(page).to have_no_content("#{discount.percent}% discount on #{discount.amount} or more items.")
    end
  end
end
