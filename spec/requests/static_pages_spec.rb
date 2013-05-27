require File.expand_path('../../spec_helper', __FILE__)

describe "StaticPages" do

  subject { page }
  describe "Home page" do
    before { visit root_path }

    it { should have_content('Sample App') }

    it { should have_title(full_title('')) } 

    it { should_not have_title('| Home') }

  end

  describe "Help page" do
    before { visit help_path }
    it { should have_content('Help') } 

    it { expect(page).to have_title(full_title("Help")) }
  end

  describe "About page" do
    before { visit about_path }
    it { expect(page).to have_content('About Us') }
    it { expect(page).to have_title(full_title("About Us")) } 
  end

  describe "Contact page" do
    before { visit contact_path }
    it { expect(page).to have_content('Contact') } 
    it { expect(page).to have_title(full_title("Contact")) } 
  end
end
