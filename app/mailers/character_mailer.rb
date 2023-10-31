class CharacterMailer < ApplicationMailer
    default template_path: 'character_mailer'
    default to: ENV['MAIL_RECIPIENT'], from: ENV['GMAIL_USERNAME']
  
    def character_update_email(new_characters_count, total_characters_count)
      @new_characters_count = new_characters_count
      @total_characters_count = total_characters_count
      
      mail(subject: 'Character Data Update')
    end
  end