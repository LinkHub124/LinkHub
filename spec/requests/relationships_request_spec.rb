require 'rails_helper'

RSpec.describe 'Relationshipsコントローラーのテスト', type: :request do
  let(:user) { create(:user) }

  context 'GET #followings' do
    it '200 OK' do
      get user_followings_path(user_name: user.name)
      expect(response.status).to eq 200
    end
  end

  context 'GET #followers' do
    it '200 OK' do
      get user_followers_path(user_name: user.name)
      expect(response.status).to eq 200
    end
  end
  
end