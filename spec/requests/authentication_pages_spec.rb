require 'spec_helper'

describe "Authentication" do
  subject { page }
  let(:sign_in) { 'Sign in' }
  let(:sign_out) { 'Sign out' }

  describe 'signin page' do
    before { visit signin_path } 

    it { should have_content(sign_in) }
    it { should have_title(sign_in) }
  end

  describe "signin" do
    before { visit signin_path }
    
    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        valid_signin(user)
      end

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user))}
      it { should have_link(sign_out, href: signout_path)}
      it { should_not have_link(sign_in, href: signin_path)}
      describe "followed by signout" do
        before { click_link sign_out }
        it { should have_link(sign_in) }
      end
    end  

    describe 'with invalid information' do
      before { click_button sign_in }

      it { should have_title(sign_in) }
      it { should have_error_message('Invalid')}

      describe 'after visiting another page' do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error')}
      end
    end  
  end
end
