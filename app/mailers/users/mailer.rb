class Users::Mailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  def confirmation_instructions(record, token, opts={})
    opts[:subject] = "【LinkHub】メールアドレス確認手続きを完了してください"
    opts[:from] = "LinkHub<#{ENV['GOOGLE_MAIL_ADDRESS']}>"
    super
  end
  
  def reset_password_instructions(record, token, opts={})
    opts[:subject] = "【LinkHub】パスワードの変更について"
    opts[:from] = "LinkHub<#{ENV['GOOGLE_MAIL_ADDRESS']}>"
    super
  end
end


 # 参考 https://github.com/heartcombo/devise/wiki/How-To:-Use-custom-mailer