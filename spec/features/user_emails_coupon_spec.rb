require 'spec_helper'

feature 'User emails coupon' do
  background do
    User.create!(email: 'kcjarvis56@hotmail.com', password: '123456', password_confirmation: '123456', full_name: 'Kirk Jarvis', user_name: 'kjarvis', terms: true, verified_email: true)
    store1 = Fabricate(:store, commission: 10)
    coupon = Array.new
    (1..7).each do |i|
      coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: "COUP#{i}",start_date: Time.now - i.day, end_date: Time.now + i.day )
      User.find(1).coupons << coupon[i]
    end
  end

  scenario "session user sends coupon email valid email", :js => true do
    sign_in_now
    find("#coupon_email_button_1").click
    fill_in_modal('test@test.com')
    page.should have_content "You have emailed test@test.com the coupon."
  end

  scenario "session user sends coupon email invalid email", :js => true do
    sign_in_now
    find("#coupon_email_button_1").click
    fill_in_modal('test@test')
    page.should have_content 'Try again!'
  end

  def sign_in_now
    visit sign_in_path
    fill_in "User name", with: 'kjarvis'
    fill_in "Password", with: '123456'
    click_button "Sign in"
  end

  def fill_in_modal(email)
    within(:xpath, "/html/body/div[1]/div[4]/div/div[3]/div/div/div/div[1]/div/div/div[1]/div/div/div[2]/form/div[2]") do
      fill_in 'Email Address', :with => email
    end
    find(:xpath, "/html/body/div[1]/div[4]/div/div[3]/div/div/div/div[1]/div/div/div[1]/div/div/div[2]/form/fieldset/input").click
  end
end