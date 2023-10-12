require 'rails_helper'

RSpec.describe 'Themeモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { theme.valid? }

    let(:user) { create(:user) }
    let!(:theme) { create(:theme, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        theme.title = ''
        is_expected.to eq false
      end

      it '50文字以下であること: 50文字はo' do
        theme.title = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end

      it '50文字以下であること: 51文字はx' do
        theme.title = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end

    context 'post_statusカラム' do
      it '空欄でないこと' do
        theme.post_status = nil
        is_expected.to eq false
      end

      it '0,1,2のどれかである: [0, 2]はo' do
        theme.post_status = Faker::Number.between(from: 0, to: 2)
        is_expected.to eq true
      end

      it '0,1,2のどれかである: [3, 100]はx' do
        theme.post_status = Faker::Number.between(from: 3, to: 100)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    subject { theme.valid? }

    let(:user) { create(:user) }
    let!(:theme) { create(:theme, user_id: user.id) }

    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Theme.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Linkモデルとの関係' do
      it '1:Nとなっている' do
        expect(Theme.reflect_on_association(:links).macro).to eq :has_many
      end

      before { create_list(:link, 10, theme: theme) }

      it '紐づくLinkの数は最大10個' do
        is_expected.to eq true
      end

      it '紐づくLinkの数は最大10個: 11個でx' do
        create(:link, theme: theme)
        is_expected.to eq false
      end
    end
  end
end
