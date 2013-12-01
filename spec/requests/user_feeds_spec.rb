require 'spec_helper'

describe "User feeds" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    31.times { FactoryGirl.create(:micropost, user: user) }
    sign_in user
    visit user_path(user, format: :atom)
  end

  it { should have_title("Page 1 of #{user.email}") }

  it "should list each micropost" do
    user.microposts.paginate(page: 1).each do |micropost|
      expect(page).to have_selector('entry > content', text: micropost.content)
    end
  end
end
