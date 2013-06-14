require 'spec_helper'

describe Message do

  let(:user) { FactoryGirl.create(:user) }
  before { @message = user.messages.build(content: "Lorem ipsum", recipient: FactoryGirl.create(:user)) }

  subject { @message }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @message.user_id = nil }
    it { should_not be_valid }
  end

  describe "when recipient_id is not present" do
    before { @message.recipient_id = nil }
    it { should_not be_valid }
  end

  describe "when user_id equals recipient_id" do
    before { @message.recipient_id = user.id }
    it { should_not be_valid }
  end

  describe "when blank content" do
    before { @message.content = "" }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @message.content = "a"*141 }
    it { should_not be_valid }
  end
end
