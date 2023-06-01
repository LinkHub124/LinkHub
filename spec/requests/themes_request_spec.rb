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

  describe 'user1 login' do
    before do
      user1.confirm
      sign_in user1
    end

    describe 'GET #index_follow' do
      it 'returns HTTP status as 200 OK' do
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
      it 'returns HTTP status as 200 OK' do
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
      it 'returns HTTP status as 302 Redirect' do
        post themes_path(user_name: user1.name), params: { theme: { title: 'test1' } }
        expect(response).to have_http_status(:redirect)
      end

      it 'returns HTTP status as 302 Redirect' do
        post themes_path(user_name: user2.name), params: { theme: { title: 'test2' } }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #show' do
      context 'access private_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: private_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Private theme by user1')
        end
      end

      context 'access limited_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: limited_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user1')
        end
      end

      context 'access released_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'access private_theme2' do
        it 'returns HTTP status as 404 Not Found' do
          get theme_path(user_name: user2.name, theme_hashid: private_theme2.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user2')
        end
      end

      context 'access limited_theme2' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user2.name, theme_hashid: limited_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user2')
        end
      end

      context 'access released_theme2' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user2')
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'GET #edit' do
      context 'posting user matches current_user' do
        it 'returns HTTP status as 200 OK' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'posting user does not match current_user' do
        it 'returns HTTP status as 404 Not Found' do
          get edit_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      context 'posting user matches current_user' do
        it 'returns HTTP status as 302 Redirect' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: 'test1', post_status: 0 } }
          expect(response).to have_http_status(:redirect)
        end
      end

      context 'posting user does not match current_user' do
        it 'returns HTTP status as 404 Not Found' do
          patch update_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test2', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test3', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'posting user matches current_user and validation errors occur' do
        it 'returns HTTP status as 422 Unprocessable Entity' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: '', post_status: 0 } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'posting user matches current_user' do
        it 'returns HTTP status as 302 Redirect' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:redirect)
        end
      end

      context 'posting user does not match current_user' do
        it 'returns HTTP status as 404 Not Found' do
          delete destroy_theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'not login' do
    context 'GET #index_follow' do
      it 'returns HTTP status as 302 Redirect' do
        get index_follow_path
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #index' do
      it 'returns HTTP status as 200 OK' do
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
      it 'returns HTTP status as 302 Redirect' do
        post themes_path(user_name: user1.name), params: { theme: { title: 'test1' } }
        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'GET #show' do
      context 'access private_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: private_theme1.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user1')
        end
      end

      context 'access limited_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: limited_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user1')
        end
      end

      context 'access released_theme1' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user1')
        end
      end

      context 'access private_theme2' do
        it 'returns HTTP status as 404 Not Found' do
          get theme_path(user_name: user2.name, theme_hashid: private_theme2.hashid)
          expect(response).to have_http_status(:not_found)
          expect(response.body).not_to include('Private theme by user2')
        end
      end

      context 'access limited_theme2' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user2.name, theme_hashid: limited_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Limited theme by user2')
        end
      end

      context 'access released_theme2' do
        it 'returns HTTP status as 200 OK' do
          get theme_path(user_name: user2.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Released theme by user2')
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          get theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'GET #edit' do
      context 'access user1 theme' do
        it 'returns HTTP status as 404 Not Found' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          get edit_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      context 'access user1 theme' do
        it 'returns HTTP status as 404 Redirect' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid), params: { theme: { title: 'test1', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          patch update_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid), params: { theme: { title: 'test3', post_status: 0 } }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'access user1 theme' do
        it 'returns HTTP status as 404 Not Found' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme1.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'access non-existent theme' do
        it 'returns HTTP status as 404 Not Found' do
          delete destroy_theme_path(user_name: user1.name, theme_hashid: released_theme2.hashid)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end