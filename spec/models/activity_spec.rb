require 'spec_helper'

describe Activity do
  it { should belong_to(:store) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:store_id) }
  it { should validate_presence_of(:user_id) }

  let(:store1)  { Fabricate(:store, name: 'store1', commission: 4 ) }
  let(:user1) { Fabricate(:user, full_name: 'user1') }
  let(:activity1) { Fabricate(:activity, user_id: user1.id, store_id: store1.id) }

  describe "user_name" do
    it "returns store name" do
      expect(activity1.user_name).to eq("user1")
    end
  end
end
