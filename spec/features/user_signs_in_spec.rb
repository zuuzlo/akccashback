require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(email: 'john@example.com', password: 'sd3472307', password_confirmation: 'sd3472307', full_name: 'John Smith', user_name: 'smith', terms: true, verified_email: true)
  end

  scenario "with existing username", :js => true do
    visit sign_in_path
    fill_in "user_name", with: "smith"
    fill_in "password", with: "sd3472307"
    click_button "Sign in"
    page.should have_content "You are now signed in!"
    page.should have_content "smith"
  end
end