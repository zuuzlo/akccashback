require 'spec_helper'

feature 'User uses favorites' do
  background do
    User.create!(email: 'kcjarvis56@hotmail.com', password: '123456', password_confirmation: '123456', full_name: 'Kirk Jarvis', user_name: 'kjarvis', terms: true, verified_email: true)
    store1 = Fabricate(:store, commission: 10)
    coupon = Array.new
    (1..7).each do |i|
      coupon[i] = Fabricate(:coupon,store_id: store1.id, title: "coupon#{i}", code: "COUP#{i}",start_date: Time.now - i.day, end_date: Time.now + i.day )
      User.find(1).coupons << coupon[i] if i % 2 == 0
    end
  end

  scenario "session user adds coupon to favorites", :js => true do
    sign_in_now
    goto_home_page
    find("#toggle_favorite_1").click
    find(:xpath, "/html/body/div/header/nav/div[2]/ul[1]/li[1]/a").click
    text = "#{Coupon.find(1).title}"
    page.should have_content text
  end

  scenario "session user removes coupon from favorites", :js => true do
    sign_in_now
    find("#toggle_favorite_2").click
    find(:xpath, "/html/body/div/header/nav/div[2]/ul[1]/li[1]/a").click
    text = "#{Coupon.find(2).title}"
    expect(page).not_to have_content text
  end

  def sign_in_now
    visit sign_in_path
    fill_in "User name", with: 'kjarvis'
    fill_in "Password", with: '123456'
    click_button "Sign in"
  end
end