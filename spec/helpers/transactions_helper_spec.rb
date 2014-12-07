require 'spec_helper'

describe TransactionsHelper do
  describe "#available_balance" do
    let!(:user1) { Fabricate(:user) }
    let!(:store1) { Fabricate(:store) }
    let!(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id) }
    let!(:trans1) { Fabricate(:transaction, user_id: user1.id) }
    
    it "returns proper available balance" do
      expect(helper.available_balance(user1)).to eq(40)
    end
  end
end