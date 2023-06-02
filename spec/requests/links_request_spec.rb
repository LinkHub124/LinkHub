require 'rails_helper'

RSpec.describe 'Linksコントローラーのテスト', type: :request do
  let!(:user1)  { create(:user) }
  let!(:theme1)  { create(:theme, title: 'Theme by user1', user: user1, post_status: 2) }
  let!(:user2)  { create(:user) }
  let!(:theme2)  { create(:theme, title: 'Theme by user2', user: user2, post_status: 2) }

  describe 'user1でログイン' do
    before do
      user1.confirm
      sign_in user1
    end

    describe 'POST #create' do
      context 'user1のテーマに追加' do
        it '201 Createdを返し、正しく保存されている' do
          post theme_links_path(user_name: user1.name, theme_hashid: theme1.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:created)
          expect(Link.count).to eq(1)
          expect(Link.last.subtitle).to eq('Link subtitle by user1')
          expect(Link.last.caption).to eq('Link caption by user1')
          expect(OneLink.count).to eq(1)
          expect(OneLink.last.url_title).to eq('Google')
        end

        it '422 Unprocessable Entityを返す' do
          post theme_links_path(user_name: user1.name, theme_hashid: theme1.hashid), params: { link: { subtitle: '', caption: '', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user2のテーマに追加' do
        it '404 Not Foundを返す' do
          post theme_links_path(user_name: user2.name, theme_hashid: theme2.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマに追加' do
        it '404 Not Foundを返す' do
          post theme_links_path(user_name: user1.name, theme_hashid: theme2.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      let!(:link1) { create(:link, subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', theme: theme1) }
      let!(:one_link1) { create(:one_link, url: 'https://google.com', rate: 3, link: link1) }
      let!(:link2) { create(:link, subtitle: 'Link subtitle by user2', caption: 'Link caption by user2', theme: theme2) }
      let!(:one_link2) { create(:one_link, url: 'https://google.com', rate: 3, link: link2) }

      context 'user1のテーマに追加' do
        it '200 OKを返し、更新できる' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { id: one_link1.id, url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:ok)
          expect(Link.count).to eq(2)
          expect(Link.first.subtitle).to eq('Link subtitle edited by user1')
          expect(Link.first.caption).to eq('Link caption edited by user1')
          expect(OneLink.count).to eq(3)
          expect(OneLink.last.url_title).to eq('Yahoo! JAPAN')
        end

        it '422 Unprocessable Entityを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link1.hashid), params: { link: { subtitle: '', caption: '', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'user2のテーマに追加' do
        it '404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user2.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマに追加' do
        it 'theme.user != userのとき404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end

        it 'link.theme != themeのとき404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link2.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:link1) { create(:link, subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', theme: theme1) }
      let!(:one_link1) { create(:one_link, url: 'https://google.com', rate: 3, link: link1) }
      let!(:link2) { create(:link, subtitle: 'Link subtitle by user2', caption: 'Link caption by user2', theme: theme2) }
      let!(:one_link2) { create(:one_link, url: 'https://google.com', rate: 3, link: link2) }

      context 'user1のテーマのリンク集を削除' do
        it '200 OKを返し、リンク集を削除' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link1.hashid), xhr: true
          expect(response).to have_http_status(:ok)
          expect(Link.count).to eq(1)
          expect(OneLink.count).to eq(1)
        end
      end

      context 'user2のテーマのリンク集を削除' do
        it '404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user2.name, theme_hashid: theme2.hashid, link_hashid: link2.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマのリンク集を削除' do
        it 'theme.user != userのとき404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end

        it 'link.theme != themeのとき404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link2.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe '未ログイン' do
    describe 'POST #create' do
      context 'user1のテーマに追加' do
        it '404 Not Foundを返す' do
          post theme_links_path(user_name: user1.name, theme_hashid: theme1.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'user2のテーマに追加' do
        it '404 Not Foundを返す' do
          post theme_links_path(user_name: user2.name, theme_hashid: theme2.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマに追加' do
        it '404 Not Foundを返す' do
          post theme_links_path(user_name: user1.name, theme_hashid: theme2.hashid), params: { link: { subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'PATCH #update' do
      let!(:link1) { create(:link, subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', theme: theme1) }
      let!(:one_link1) { create(:one_link, url: 'https://google.com', rate: 3, link: link1) }
      let!(:link2) { create(:link, subtitle: 'Link subtitle by user2', caption: 'Link caption by user2', theme: theme2) }
      let!(:one_link2) { create(:one_link, url: 'https://google.com', rate: 3, link: link2) }

      context 'user1のテーマに追加' do
        it '404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { id: one_link1.id, url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'user2のテーマに追加' do
        it '404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user2.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマに追加' do
        it 'theme.user != userのとき404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end

        it 'link.theme != themeのとき404 Not Foundを返す' do
          patch update_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link2.hashid), params: { link: { subtitle: 'Link subtitle edited by user1', caption: 'Link caption edited by user1', one_links_attributes: {'0': { url: 'https://google.com', rate: 3 }, '1': { url: 'https://yahoo.co.jp', rate: 3 } } } }, xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    describe 'DELETE #destroy' do
      let!(:link1) { create(:link, subtitle: 'Link subtitle by user1', caption: 'Link caption by user1', theme: theme1) }
      let!(:one_link1) { create(:one_link, url: 'https://google.com', rate: 3, link: link1) }
      let!(:link2) { create(:link, subtitle: 'Link subtitle by user2', caption: 'Link caption by user2', theme: theme2) }
      let!(:one_link2) { create(:one_link, url: 'https://google.com', rate: 3, link: link2) }

      context 'user1のテーマのリンク集を削除' do
        it '404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link1.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'user2のテーマのリンク集を削除' do
        it '404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user2.name, theme_hashid: theme2.hashid, link_hashid: link2.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end

      context '存在しないテーマのリンク集を削除' do
        it 'theme.user != userのとき404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme2.hashid, link_hashid: link1.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end

        it 'link.theme != themeのとき404 Not Foundを返す' do
          delete destroy_theme_link_path(user_name: user1.name, theme_hashid: theme1.hashid, link_hashid: link2.hashid), xhr: true
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end