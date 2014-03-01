class UserMailer < ActionMailer::Base
  default from: "cricketadmin@cuthberts.org.uk"

  def invite_email(token)
  	@token = token
  	#binding.pry
  	@url = 'http://cricket.cuthberts.org.uk/signup?email=' + CGI.escape(@token.email) +
  		'&name=' + CGI.escape(@token.realname) +
  		'&tokenstr=' + CGI.escape(@token.tokenstr)
  	mail(to: @token.email, subject: 'Sign up for Helperby Fantasy Cricket')
  end
end
