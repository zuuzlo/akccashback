require 'spec_helper'

describe Transaction do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  describe "#amount_cannot_be_more_than_available" do
      let!(:user1) { Fabricate(:user) }
      let!(:store1) { Fabricate(:store) }
      let!(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id) }
    
    it "should have an error if Transaction is greater then available" do
      Transaction.new(user_id: user1.id, amount_cents: 30000).should have(1).errors_on(:amount_cents)
    end

    it "should not have an error if Transaction is less then available" do
      Transaction.new(user_id: user1.id, amount_cents: 30).should have(0).errors_on(:amount_cents)
    end

    it "should not have an error if Transaction is equal to available" do
      Transaction.new(user_id: user1.id, amount_cents: 60).should have(0).errors_on(:amount_cents)
    end

    it "error if other transaction plus amount to withdraw is greater then available" do
      Fabricate(:transaction, amount_cents: 45, user_id: user1.id)
      Transaction.new(user_id: user1.id, amount_cents: 20).should have(1).errors_on(:amount_cents)
    end

    it "error if other transactions and amount to withdraw greater then available" do
      Fabricate(:transaction, amount_cents: 30, user_id: user1.id)
      Fabricate(:transaction, amount_cents: 20, user_id: user1.id)
      Transaction.new(user_id: user1.id, amount_cents: 20).should have(1).errors_on(:amount_cents)
    end

    it "no error if transactions and amount to withdraw less than available" do
      Fabricate(:transaction, amount_cents: 30, user_id: user1.id)
      Fabricate(:transaction, amount_cents: 20, user_id: user1.id)
      Transaction.new(user_id: user1.id, amount_cents: 10).should have(0).errors_on(:amount_cents)
    end
  end
end
