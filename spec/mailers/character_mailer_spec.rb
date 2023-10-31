require 'rails_helper'

RSpec.describe CharacterMailer, type: :mailer do
  it 'sends a notification email' do
    email = CharacterMailer.character_update_email(1, 20).deliver_now

    assert_equal 1, ActionMailer::Base.deliveries.size

    expect(email.subject).to eq('Character Data Update')
    expect(email.to).to eq([ENV['MAIL_RECIPIENT']])

    email = ActionMailer::Base.deliveries.last
    assert_equal "Character Data Update", email.subject
    assert_equal ENV['MAIL_RECIPIENT'], email.to[0]
  end
end
