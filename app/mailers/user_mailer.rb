class UserMailer < ApplicationMailer
  def send_password
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: '【LinkHub】ご登録ありがとうございます')
  end
end