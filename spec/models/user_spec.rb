require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let(:user) { create(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字はx' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字はo' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字はo' do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字はx' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end

      it '特殊文字を含まない' do
        user.name = Faker::Internet.password(min_length: 10, max_length: 10, special_characters: true)
        is_expected.to eq false
      end

      let!(:other_user) { create(:user) }

      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '200文字以下であること: 200文字はo' do
        user.introduction = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字はx' do
        user.introduction = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Themeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:themes).macro).to eq :has_many
      end
    end
  end
end
