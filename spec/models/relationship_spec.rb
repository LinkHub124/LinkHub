require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    context 'user1がuser2をフォロー' do
      before { user1.follow(user2.name) }

      it 'user1がuser2をフォロー' do
        expect(user1.following?(user2)).to eq true
        expect(user2.followers.include?(user1)).to eq true
      end

      it 'user1がuser2をアンフォロー' do
        user1.unfollow(user2.name)
        expect(user1.following?(user2)).to eq false
        expect(user2.followers.include?(user1)).to eq false
      end
    end

    context 'FollowerとFollowedの組み合わせが一意であること' do
      it '二つ存在' do
        expect {
          create(:relationship, follower: user1, followed: user2)
          create(:relationship, follower: user1, followed: user2)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:relationships).macro).to eq :has_many
      end

      it 'Relationshipが削除されたら、それに紐づくフォロワーも削除される' do
        user = create(:user)
        follower = create(:user)
        relationship = create(:relationship, follower: follower, followed: user)

        expect { relationship.destroy }.to change { user.followers.count }.by(-1)
      end
    end

    context 'reverse_of_relationshipsモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end

      it 'Relationshipが削除されたら、それに紐づくフォローも削除される' do
        user = create(:user)
        follower = create(:user)
        relationship = create(:relationship, follower: follower, followed: user)

        expect { relationship.destroy }.to change { follower.followings.count }.by(-1)
      end
    end
  end
end
