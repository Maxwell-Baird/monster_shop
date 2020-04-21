require 'rails_helper'

RSpec.describe 'discount new page', type: :feature do
  describe 'As a user' do
    before :each do
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @merchant_user = User.create(name: "David", address: "123 Test St", city: "Denver", state: "CO", zip: "80204", email: "123@example.com", password: "password", role: 2)
      @dog_shop.add_employee(@merchant_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
      @discount = @dog_shop.discounts.create(percent: 5, amount: 20)
      visit "/merchant/discounts/#{@discount.id}/edit"
    end

    it 'I can edit a discount' do



      fill_in :percent, with: 15
      fill_in :amount, with: 30

      click_button "Update Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("15% discount on 30 or more items.")
    end

    it 'I can edit a part of the discount' do

      fill_in :percent, with: 15

      click_button "Update Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("15% discount on 20 or more items.")
    end

    it 'I cannot edit a discount if all fields are not filled in' do

      fill_in :percent, with: 13
      fill_in :amount, with: ""


      click_button "Update Discount"

      expect(page).to have_content("Unable to update discount: Amount can't be blank.")
      expect(page).to have_button("Create Discount")
    end
  end
end
