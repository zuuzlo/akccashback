class AppMailer < ActionMailer::Base
  def notify_on_registor(user)
    @user = user
    mail to:@user.email, from: 'kirk@example.com', subject: "Thank you for registering at All Kohls Coupons Cash Back."
  end

  def send_forgot_password(user)
    @user = user
    mail to: @user.email, from: 'kirk@example.com', subject: "Reset password at All Kohls Coupons Cash Back"
  end

  def send_invitation(invitation, user)
    @user = user
    @invitation = invitation
    mail to: @invitation.friends_email, from: 'kirk@example.com', subject: "You have been invited to join All Kohls Coupons Cash Back"
  end
end