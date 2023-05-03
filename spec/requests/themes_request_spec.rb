require 'rails_helper'

RSpec.describe 'Themesコントローラーのテスト', type: :request do
  let(:user) { create(:user) }
  let(:theme) { create(:theme, user: user, post_status: 2) }

  describe 'ログイン済み' do
    before do
      user.confirm
      sign_in user
    end

    context 'GET #index_follow' do
      it '200 OK' do
        get index_follow_path
        expect(response.status).to eq 200
      end
    end

    context 'GET #index' do
      it '200 OK' do
        get root_path
        expect(response.status).to eq 200
      end
    end

    context 'GET #show' do
      it '200 OK' do
        get theme_path(user_name: user.name, theme_hashid: theme.hashid)
        expect(response.status).to eq 200
      end
    end

    context 'GET #edit' do
      it '200 OK' do
        get edit_theme_path(user_name: user.name, theme_hashid: theme.hashid)
        expect(response.status).to eq 200
      end
    end
  end

  describe '未ログイン' do
    context 'GET #index_follow' do
      it '200 OK' do
        get index_follow_path
        expect(response.status).to eq 302
      end
    end

    context 'GET #index' do
      it '200 OK' do
        get root_path
        expect(response.status).to eq 200
      end
    end

    context 'GET #show' do
      it '200 OK' do
        get theme_path(user_name: user.name, theme_hashid: theme.hashid)
        expect(response.status).to eq 200
      end
    end

    context 'GET #edit' do
      it '500 Internal Server Error' do
        get edit_theme_path(user_name: user.name, theme_hashid: theme.hashid)
        expect(response.status).to eq 500
      end
    end
  end
  
end