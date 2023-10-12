require 'rails_helper'

RSpec.describe 'Linkモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { link.valid? }

    let(:user) { create(:user) }
    let(:theme) { create(:theme, user: user) }
    let!(:link) { create(:link, theme: theme) }

    context 'subtitleカラム' do
      it '空欄でないこと' do
        link.subtitle = ''
        is_expected.to eq false
      end

      it '50文字以下であること: 50文字はo' do
        link.subtitle = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end

      it '50文字以下であること: 51文字はx' do
        link.subtitle = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end

    context 'captionカラム' do
      it '500文字以下であること: 500文字はo' do
        link.caption = Faker::Lorem.characters(number: 500)
        is_expected.to eq true
      end

      it '500文字以下であること: 501文字はx' do
        link.caption = Faker::Lorem.characters(number: 501)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    subject { link.valid? }

    let(:user) { create(:user) }
    let(:theme) { create(:theme, user: user) }
    let!(:link) { create(:link, theme: theme) }

    context 'Themeモデルとの関係' do
      it 'N:1となっている' do
        expect(Link.reflect_on_association(:theme).macro).to eq :belongs_to
      end
    end

    context 'OneLinkモデルとの関係' do
      it '1:Nとなっている' do
        expect(Link.reflect_on_association(:one_links).macro).to eq :has_many
      end
    end
  end
end
