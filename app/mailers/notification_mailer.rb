class NotificationMailer < ActionMailer::Base
  def notify(notification)
    @notification = notification
    mail(bcc: notification.recipients, from: notification.respond, subject: notification.subject)
  end
end
