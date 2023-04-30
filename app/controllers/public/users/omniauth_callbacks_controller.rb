class Public::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Description: Googleアカウントでの認証を行う.
  def google_oauth2
    callback_from
  end

  private

  # Description: ユーザー新規登録の場合はメール送信をする.
  def callback_from
    user = User.find_for_oauth(request.env['omniauth.auth'])
    unless user.persisted? # ユーザーが保存済みかどうか判断.
      user.skip_confirmation!
      if user.save
        password = user.password
        UserMailer.with(user: user, password: password).send_password.deliver_now
        set_flash_message :notice, :signed_up_gmail
      else
        set_flash_message :notice, :signed_up_gmail_failure
      end
    end
    sign_in_and_redirect user
  end
end
