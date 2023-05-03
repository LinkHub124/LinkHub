require 'rails_helper'

RSpec.describe 'Usersコントローラーのテスト', type: :request do
  let(:user) { create(:user) }

  describe 'ログイン済み' do
    before do
      user.confirm
      sign_in user
    end

    context 'GET #show' do
      it '200 OK' do
        get user_path(user_name: user.name)
        expect(response.status).to eq 200
      end
    end
  end

  describe '未ログイン' do
    context 'GET #show' do
      it '200 OK' do
        get user_path(user_name: user.name)
        expect(response.status).to eq 200
      end
    end
  end
  
end