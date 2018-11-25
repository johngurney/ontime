class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def confirmation_email(user, base_url)

    @confirmation_url = base_url + '/myuser/confirmation?confirmation_token=' + user.confirmation_token
    #http://localhost:3000/users/confirmation?confirmation_token=x8gcudMm2xyuJGwA6UvK
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end

  def summons_email(content, myuser, task, base_url)

    #stg ='<a href ="#" onClick=\"window.open(\'' + tasks_message_forum_path(1) + '\', \'MsgWindow\', \'width=400,height=500,left=400,top=100,location=0,status=0,titlebar=0,toolbar=0,menu=0\');\" >Message forum</a>'
    #stg ='test<a href ="' + base_url + summons_landing_path(1) + '">Message forum</a>'
    mail(to: 'dan.tench@gmail.com', subject: 'Summons to join message forum') do |format|
      format.html { render html: content.gsub(/(\r)?\n/, '<br />').sub!("[FIRST_NAME]", myuser.first_name).sub!("[LINK]", link_to("Click here", base_url + summons_landing_path(task))).to_s.html_safe }
    end
  end

end
