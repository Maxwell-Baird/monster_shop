require 'rails_helper'

RSpec.describe 'discount new page', type: :feature do
  describe 'As a user' do
    it 'I can create a new discount' do
      visit '/merchant/discounts/new'


      fill_in :percent, with: 10
      fill_in :amount, with: 25

      click_button "Create Discount"

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("10% discount on 25 or more items.")
    end

    it 'I cannot create a discount if all fields are not filled in' do
      visit '/merchant/discounts/new'

      fill_in :percent, with: 13
      fill_in :amount, with: ''


      click_button "Create Discount"

      expect(page).to have_content("amount can't be blank")
      expect(page).to have_button("Create Discount")
    end
  end
end
