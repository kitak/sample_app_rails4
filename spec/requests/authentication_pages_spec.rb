require 'spec_helper'

describe "Authentication" do
  subject { page }
  let(:sign_in_text) { 'Sign in' }
  let(:sign_out_text) { 'Sign out' }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content(sign_in_text) }
    it { should have_title(sign_in_text) }
  end

  describe "signin" do
    before { visit signin_path }

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        valid_signin(user)
      end

      it { should have_title(user.name) }
      it { should have_link('Users', href: users_path)}
      it { should have_link('Profile', href: user_path(user))}
      it { should have_link('Settings', href: edit_user_path(user))}
      it { should have_link(sign_out_text, href: signout_path)}
      it { should_not have_link(sign_in_text, href: signin_path)}

      describe "don't display `sign up` button" do
        before { click_link "Home" }
        specify { expect(page).not_to have_link("Sign up now!", href: signup_path)}
      end

      describe "followed by signout" do
        before { click_link sign_out_text }
        it { should have_link(sign_in_text) }
      end
    end

    describe 'with invalid information' do
      before { click_button sign_in_text }

      it { should have_title(sign_in_text) }
      it { should have_error_message('Invalid')}
      it { should_not have_link('Profile') }
      it { should_not have_link('Settings')}
      it { should_not have_link(sign_out_text, href: signout_path)}
      it { should have_link(sign_in_text, href: signin_path)}

      describe 'after visiting another page' do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error')}
      end
    end
  end

  describe "authorization" do
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "in the Users controller" do
        describe "visiting the new page" do
          before { visit new_user_path }
          it { should have_link('view my profile', href: user_path(user)) }
        end

        describe "submitting to the create action" do
          before { post users_path(user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
      
    end

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title("Edit user")
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user){ FactoryGirl.create(:user, email: "wrong@example.com") }

      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title("Edit user")) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:other_admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(other_admin) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "in the Microposts controller" do
      
      describe "submitting to the create action" do
        before { post microposts_path }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "sbumitting to the destroy action" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { expect(response).to redirect_to(signin_path) }
      end
    end

  end
end
