def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user, verified_email: TRUE)).id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def set_admin_user(a_user=nil)
  user = a_user || Fabricate(:user)
  set_current_user(user)
  user.admin = true
  user.save
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user) 
  visit sign_in_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Log in"
end

def sign_out
  visit sign_out_path
end

def goto_home_page
  click_link("Videos")
end
