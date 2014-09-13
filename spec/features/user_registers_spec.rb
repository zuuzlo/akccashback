require 'spec_helper'

feature "New user registers" do
  
  before do
    clear_emails
    visit  new_user_path
  end

  scenario "user enters valid user info" do
    fill_in 'User name', :with => 'newuser'
    fill_in 'Email', :with => 'newuser@newuser.com'
    find('#user_password').set('123456')
    find('#user_password_confirmation').set('123456')
    check('I agree with the Terms of Service.')
    click_button 'Register'
    page.should have_content "Welcome, to All Kohls Coupons Cash Back App"
    page.should have_content "Sign in"
  end


end