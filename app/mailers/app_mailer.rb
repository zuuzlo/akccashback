class AppMailer < ActionMailer::Base
  def notify_on_registor(user)
    @user = user
    mail to:@user.email, from: 'noreply@allkohlscoupons.com', subject: "Thank you for registering at All Kohls Coupons Cash Back."
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, from: 'noreply@allkohlscoupons.com', subject: "Reset password at All Kohls Coupons Cash Back"
  end

  def send_invitation(invitation, user)
    @user = user
    @invitation = invitation
    mail to: @invitation.friends_email, from: 'noreply@allkohlscoupons.com', subject: "You have been invited to join All Kohls Coupons Cash Back"
  end

  def notify_transaction(user, transaction)
    @user = user
    @transaction = transaction
    mail to: @user.email, from: 'noreply@allkohlscoupons.com', subject: "All Kohls Coupons Cash Back has recieved your withdrawal request."
  end
end