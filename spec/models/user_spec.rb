require 'spec_helper'

describe User do
  before { kirk1 = Fabricate(:user) }
  it { should validate_presence_of(:email) }
  it { should_not allow_value("fads").for(:email) } 
  it { should allow_value("KJa.aa12@yah.com").for(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:user_name) }
  it { should_not allow_value("kj ar").for(:user_name) }
  it { should allow_value("kcjarvis56").for(:user_name) }
  #password_confirmation 
  it { should_not allow_value('12345').for(:password) }
  it { should allow_value('123456').for (:password) }  
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:user_name) }
  it { should have_many(:transactions).dependent(:destroy) }
  it { should have_many(:activities).dependent(:destroy) }

  it { should allow_value(true).for(:terms) }
  it { should_not allow_value(nil).for(:terms) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

  it "should generate a token" do
    kirk = Fabricate(:user)
    expect(kirk.token).to be_present
  end
end
