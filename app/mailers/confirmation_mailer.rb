class ConfirmationMailer < ApplicationMailer

    def confirmation_email(email_address)
      mail(to: email_address, subject: "Thank You For Your FüD Order!")
    end
end
