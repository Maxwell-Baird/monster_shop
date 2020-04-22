require 'rails_helper'

describe Discount, type: :model do


  describe "relationships" do
    it {should belong_to :merchant}
  end

  describe "validations" do
    it { should validate_presence_of :percent }
    it { should validate_presence_of :amount }
  end

end
