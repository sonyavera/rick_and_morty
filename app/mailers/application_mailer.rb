class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_ADDRESS']
end