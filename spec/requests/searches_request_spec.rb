require 'rails_helper'

RSpec.describe 'Searchesコントローラーのテスト', type: :request do
  context 'GET #search' do
    it '200 OK' do
      get search_path
      expect(response.status).to eq 200
    end
  end
end