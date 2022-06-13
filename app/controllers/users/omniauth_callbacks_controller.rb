class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # コメントアウト外して、処理追加(8行目あたり)
  def twitter
    callback_from :twitter
  end

  def google_oauth2
    callback_from :google
  end
  # 最後のendの直前に記載
  private

  # コールバック時に行う処理
  def callback_from(provider)
    provider = provider.to_s

    @user = User.find_for_oauth(request.env['omniauth.auth'])

    # persisted?でDBに保存済みかどうか判断
    if @user.persisted?
      @user.skip_confirmation!
      @user.save
      # サインアップ時に行いたい処理があればここに書きます。
      #flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @user#, event: :authentication
    else
      # サインイン
      @user.skip_confirmation!
      @user.save
      sign_in_and_redirect @user
      #session["devise.#{provider}_data"] = request.env['omniauth.auth']
      #redirect_to new_user_registration_url
    end
  end

  def provider_to_name
    if(provider=="twiter")
      return "twitter"
    else
      return "google"
    end
  end
end