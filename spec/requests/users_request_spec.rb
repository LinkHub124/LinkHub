require 'rails_helper'

RSpec.describe 'Usersコントローラーのテスト', type: :request do
  let!(:user1)  { create(:user) }
  let!(:private_theme1)  { create(:theme, title: 'Private theme by user1', user: user1, post_status: 0) }
  let!(:limited_theme1)  { create(:theme, title: 'Limited theme by user1', user: user1, post_status: 1) }
  let!(:released_theme1) { create(:theme, title: 'Released theme by user1', user: user1, post_status: 2) }
  let!(:user2)  { create(:user) }
  let!(:private_theme2)  { create(:theme, title: 'Private theme by user2', user: user2, post_status: 0) }
  let!(:limited_theme2)  { create(:theme, title: 'Limited theme by user2', user: user2, post_status: 1) }
  let!(:released_theme2) { create(:theme, title: 'Released theme by user2', user: user2, post_status: 2) }

  describe 'user1 login' do
    before do
      user1.confirm
      sign_in user1
    end

    describe 'GET #show' do
      context 'access user1' do
        it '200 OKを返し、user1が投稿した全てのテーマを表示' do
          get user_path(user_name: user1.name)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Private theme by user1')
          expect(response.body).to include('Limited theme by user1')
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'access user2' do
        it '200 OKを返し、user2が投稿した全体公開テーマのみを表示' do
          get user_path(user_name: user2.name)
          expect(response).to have_http_status(:success)
          expect(response.body).not_to include('Private theme by user2')
          expect(response.body).not_to include('Limited theme by user2')
          expect(response.body).to include('Released theme by user2')
        end
      end
    end

    describe 'PATCH #withdrawal' do
      context 'user1 withdrawal' do
        it '302 Redirectを返し、退会フラグが立つ' do
          expect(user1.is_deleted).to be false
          patch withdrawal_path, params: { user: { current_password: 'password' } }
          expect(user1.is_deleted).to be true
        end
      end
    end
  end

  describe 'not login' do
    context 'access user1' do
      it '200 OKを返し、user1が投稿した全体公開テーマのみを表示' do
        get user_path(user_name: user1.name)
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Private theme by user1')
        expect(response.body).not_to include('Limited theme by user1')
        expect(response.body).to include('Released theme by user1')
      end
    end

    context 'access user2' do
      it '200 OKを返し、user2が投稿した全体公開テーマのみを表示' do
        get user_path(user_name: user2.name)
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Private theme by user2')
        expect(response.body).not_to include('Limited theme by user2')
        expect(response.body).to include('Released theme by user2')
      end
    end

    describe 'PATCH #withdrawal' do
      context 'user1 withdrawal' do
        it '302 Redirectを返し、ログイン画面に遷移させる' do
          expect(user1.is_deleted).to be false
          patch withdrawal_path, params: { user: { current_password: 'password' } }
          expect(user1.is_deleted).to be false
        end
      end
    end
  end
  
end