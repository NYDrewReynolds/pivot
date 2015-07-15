class ApplicationMailer < ActionMailer::Base
  default from: "hello@supper-skip.herokuapp.com"
  layout 'mailer'
end
