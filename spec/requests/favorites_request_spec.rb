require 'rails_helper'

RSpec.describe 'Favoritesコントローラーのテスト', type: :request do
  let(:user) { create(:user) }

  context 'GET #index' do
    it '200 OK' do
      get user_favorites_path(user_name: user.name)
      expect(response.status).to eq 200
    end
  end
end