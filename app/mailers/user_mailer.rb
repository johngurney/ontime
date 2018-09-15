class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def confirmation_email(user, base_url)

    @confirmation_url = base_url   + '/myuser/confirmation?confirmation_token=' + user.confirmation_token
    #http://localhost:3000/users/confirmation?confirmation_token=x8gcudMm2xyuJGwA6UvK
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
    end
end
