class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]


  # get '/:user_name' => 'users#show', as: 'user'
  # ユーザー詳細画面を表示させる
  def show
    @user = User.find_by(name: params[:user_name])
    @theme_all = @user.themes.page(params[:page]).per(10)
  end


  # 内部ルート
  # ユーザー情報を更新する
  def update
    binding.pry
    if current_user.update(user_params)
      redirect_to user_path(user_name: current_user.name)
    else
      render :edit
    end
  end


  # patch '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
  # ユーザーを退会処理
  def withdrawal
    if current_user.valid_password?(params[:user][:current_password])
      # is_deletedカラムをtrueに変更することにより削除フラグを立てる
      current_user.update(is_deleted: true)
      reset_session
      flash[:notice] = "退会処理を実行いたしました"
      redirect_to root_path
    else
      redirect_to unsubscribe_path
    end
  end


  private

    # 新規登録時、名前とプロフィール画像をコントローラに通す
    def user_params
      params.fetch(:user, {}).permit(:name, :profile_image)
    end

end
