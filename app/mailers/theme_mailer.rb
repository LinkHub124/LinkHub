class ThemeMailer < ApplicationMailer
  def send_report
    @theme = params[:theme]
    # binding.pry
    mail(to: ENV['GOOGLE_MAIL_ADDRESS'], subject: "【LinkHub】通報がありました:  #{@theme.title}")
  end
end
