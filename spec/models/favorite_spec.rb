require 'rails_helper'

RSpec.describe 'Favoriteモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { favorite.valid? }

    let(:user) { create(:user) }
    let(:theme) { create(:theme, user: user) }
    let!(:favorite) { create(:favorite, theme: theme, user: user) }

    context 'ThemeとUserの組み合わせが一意であること' do
      it '一つ存在' do
        is_expected.to eq true
      end

      it '二つ存在' do
        expect { create(:favorite, theme: theme, user: user) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Themeモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:theme).macro).to eq :belongs_to
      end
    end

    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Favorite.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
