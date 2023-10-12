require 'rails_helper'

RSpec.describe 'OneLinkモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { one_link.valid? }

    let(:user) { create(:user) }
    let(:theme) { create(:theme, user: user) }
    let(:link) { create(:link, theme: theme) }
    let!(:one_link) { create(:one_link, link: link) }

    context 'urlカラム' do
      it '空欄でないこと' do
        one_link.url = ''
        is_expected.to eq false
      end
    end

    context 'rateカラム' do
      it '1以上であること: 1はo' do
        one_link.rate = 1
        is_expected.to eq true
      end

      it '1以上であること: 0はx' do
        one_link.rate = 0
        is_expected.to eq false
      end

      it '5以下であること: 5はo' do
        one_link.rate = 5
        is_expected.to eq true
      end

      it '5以下であること: 6はx' do
        one_link.rate = 6
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do

    context 'Linkモデルとの関係' do
      it 'N:1となっている' do
        expect(OneLink.reflect_on_association(:link).macro).to eq :belongs_to
      end
    end
  end
end
