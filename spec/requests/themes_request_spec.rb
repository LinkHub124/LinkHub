require 'rails_helper'

RSpec.describe 'Themesコントローラーのテスト', type: :request do
  let!(:user1)  { create(:user) }
  let!(:private_theme1)  { create(:theme, title: 'Private theme by user1', user: user1, post_status: 0) }
  let!(:limited_theme1)  { create(:theme, title: 'Limited theme by user1', user: user1, post_status: 1) }
  let!(:released_theme1) { create(:theme, title: 'Released theme by user1', user: user1, post_status: 2) }
  let!(:user2)  { create(:user) }
  let!(:private_theme2)  { create(:theme, title: 'Private theme by user2', user: user2, post_status: 0) }
  let!(:limited_theme2)  { create(:theme, title: 'Limited theme by user2', user: user2, post_status: 1) }
  let!(:released_theme2) { create(:theme, title: 'Released theme by user2', user: user2, post_status: 2) }

  describe 'user1でログイン' do
    before do
      user1.confirm
      sign_in user1
    end

    describe 'GET #index_follow' do
      it '200 OKを返し、フォローした人の全体公開テーマが表示' do
        user1.follow(user2.name)
        get index_follow_path
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Private theme by user1')
        expect(response.body).not_to include('Limited theme by user1')
        expect(response.body).not_to include('Released theme by user1')
        expect(response.body).not_to include('Private theme by user2')
        expect(response.body).not_to include('Limited theme by user2')
        expect(response.body).to include('Released theme by user2')
      end
    end

    describe 'GET #index' do
      it '200 OKを返し、全ユーザの全体公開テーマが表示' do
        get root_path
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Private theme by user1')
        expect(response.body).not_to include('Limited theme by user1')
        expect(response.body).to include('Released theme by user1')
        expect(response.body).not_to include('Private theme by user2')
        expect(response.body).not_to include('Limited theme by user2')
        expect(response.body).to include('Released theme by user2')
      end
    end

    describe 'POST #create' do
      it '302 Redirectを返す' do
        post themes_path(user_name: user1.name), params: { theme: { title: 'test1' } }
        expect(response).to have_http_status(:redirect)
      end

      it '302 Redirectを返す' do
        post themes_path(user_name: user2.name), params: { theme: { title: 'test2' } }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #show' do
      context 'private_theme1にアクセス' do
        it '200 OKを返し、非公開テーマを閲覧できる' do
          get theme_path(user_name: user1.name, theme_hashid: private_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Private theme by user1')
        end
      end

      context 'limited_theme1にアクセス' do
        it '200 OKを返し、限定公開テーマが閲覧できる' do
          get theme_path(user_name: user1.name, theme_hashid: limited_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user1')
        end
      end

      context 'released_theme1にアクセス' do
        it '200 OKを返し、全体公開テーマが閲覧できる' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'private_theme2にアクセス' do
        it '404 Not Foundを返す' do
          get theme_path(user_name: user2.name, theme_hashid: private_theme2.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user2')
        end
      end

      context 'limited_theme2にアクセス' do
        it '200 OKを返し、別ユーザの限定公開テーマが閲覧できる' do
          get theme_path(user_name: user2.name, theme_hashid: limited_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user2')
        end
      end

      context 'released_theme2にアクセス' do
        it '200 OKを返し、別ユーザの全体公開テーマが閲覧できる' do
          get theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user2')
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'GET #edit' do
      context '投稿ユーザーとログインユーザーが一致' do
        it '200 OKを返し、編集画面に遷移できる' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context '投稿ユーザーとログインユーザーが不一致' do
        it '404 Not Foundを返す' do
          get edit_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      context '投稿ユーザーとログインユーザーが一致' do
        it '302 Redirectを返す' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: 'test1', post_status: 0 } }
          expect(response).to have_http_status(:redirect)
        end
      end

      context '投稿ユーザーとログインユーザーが不一致' do
        it '404 Not Foundを返す' do
          patch update_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test2', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test3', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context '投稿ユーザーとログインユーザーが一致かつ、バリデーションエラーが発生' do
        it '422 Unprocessable Entityを返す' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: '', post_status: 0 } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      context '投稿ユーザーとログインユーザーが一致' do
        it '302 Redirectを返す' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:redirect)
        end
      end

      context '投稿ユーザーとログインユーザーが不一致' do
        it '404 Not Foundを返す' do
          delete destroy_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe '未ログイン' do
    context 'GET #index_follow' do
      it '302 Redirectを返す' do
        get index_follow_path
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #index' do
      it '200 OKを返し、全ユーザの全体公開テーマが表示' do
        get root_path
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('Private theme by user1')
        expect(response.body).not_to include('Limited theme by user1')
        expect(response.body).to include('Released theme by user1')
        expect(response.body).not_to include('Private theme by user2')
        expect(response.body).not_to include('Limited theme by user2')
        expect(response.body).to include('Released theme by user2')
      end
    end

    describe 'POST #create' do
      it '302 Redirectを返す' do
        post themes_path(user_name: user1.name), params: { theme: { title: 'test1' } }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #show' do
      context 'private_theme1にアクセス' do
        it '404 Not Foundを返す' do
          get theme_path(user_name: user1.name, theme_hashid: private_theme1.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user1')
        end
      end

      context 'limited_theme1にアクセス' do
        it '200 OKを返し、限定公開テーマが閲覧できる' do
          get theme_path(user_name: user1.name, theme_hashid: limited_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user1')
        end
      end

      context 'released_theme1にアクセス' do
        it '200 OKを返し、全体公開テーマが閲覧できる' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'private_theme2にアクセス' do
        it '404 Not Foundを返す' do
          get theme_path(user_name: user2.name, theme_hashid: private_theme2.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user2')
        end
      end

      context 'limited_theme2にアクセス' do
        it '200 OKを返し、限定公開テーマが閲覧できる' do
          get theme_path(user_name: user2.name, theme_hashid: limited_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user2')
        end
      end

      context 'released_theme2にアクセス' do
        it '200 OKを返し、全体公開テーマが閲覧できる' do
          get theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user2')
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'GET #edit' do
      context 'user1の投稿テーマ編集画面にアクセス' do
        it '404 Not Foundを返す' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      context 'user1の投稿テーマを更新する' do
        it '404 Not Foundを返す' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: 'test1', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test3', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'user1の投稿テーマを削除する' do
        it '404 Not Foundを返す' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないthemeにアクセス' do
        it '404 Not Foundを返す' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end