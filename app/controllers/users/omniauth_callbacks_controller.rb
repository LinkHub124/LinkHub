class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # コメントアウト外して、処理追加(8行目あたり)
  def twitter
    callback_from
  end

  def google_oauth2
    callback_from
  end
  # 最後のendの直前に記載

  private

  # コールバック時に行う処理
  def callback_from
    # provider = provider.to_s
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    # persisted?でDBに保存済みかどうか判断
    unless @user.persisted?
      @user.skip_confirmation!
      if @user.save
        set_flash_message :notice, :signed_up_gmail
      else
        set_flash_message :notice, :signed_up_gmail_failure
      end
      # サインアップ時に行いたい処理があればここに書きます。
      # flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: provider.capitalize)
      # flash[:notice] = I18n.t("#{@user.password}", kind: provider.capitalize)
      @password = @user.password
      UserMailer.with(user: @user, password: @password).send_password.deliver_now

      # key_len = ActiveSupport::MessageEncryptor.key_len
      # secret = Rails.application.key_generator.generate_key('salt', key_len)
      # $crypt = ActiveSupport::MessageEncryptor.new(secret)
      # encrypted = $crypt.encrypt_and_sign(@password)

      # sign_in @user
      # redirect_to registrations_complete_path(encrypted_password: encrypted)

    end
    sign_in_and_redirect @user
  end

  def provider_to_name
    if provider == 'twiter'
      'twitter'
    else
      'google'
    end
  end
end
