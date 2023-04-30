class ApplicationMailer < ActionMailer::Base
  # default from: 'from@example.com'
  # layout 'mailer'
  default from: "LinkHub<#{ENV['GOOGLE_MAIL_ADDRESS']}>",
          cc: ENV['GOOGLE_MAIL_ADDRESS']
  layout 'mailer'
end
