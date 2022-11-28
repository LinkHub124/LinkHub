class Public::Devise::SessionsController < Devise::SessionsController

  # def create
  #   #スーパークラス(devise)のcreateアクションを呼ぶ
  #   super
  #   #WelcomeMailerクラスのsend_when_signupメソッドを呼び、POSTから受け取ったuserのemailとnameを渡す
  #   # WelcomeMailer.send_when_signup(params[:user][:email], params[:user][:name]).deliver
  # end

  # def after_update_path_for(resource)
  #   super
  #   # 自分で設定した「マイページ」へのパス
  #   user_path(user_name: resource.name)
  # end

end