module ApplicationHelper
  # Description: Webページのタイトルを動的に変更.
  def full_title(page_title = '')
    base_title = 'LinkHub'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Description: Webページの説明を動的に変更.
  def full_description(page_description = '')
    base_description = 'LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。'
    if page_description.empty?
      base_description
    else
      base_description
    end
  end

  # Description: ドメイン名とホスト名を抜き出す.
  def get_tld(url)
    sz = url.length
    if url.slice(0..6) == 'http://'
      url = url.slice(7..sz)
    elsif url.slice(0..7) == 'https://'
      url = url.slice(8..sz)
    end
    sz = url.length
    idx = -1
    (0..sz).each do |num|
      if url[num] == '/'
        idx = num
        break
      end
    end
    url = url.slice(0..idx - 1) unless idx == -1
    url
  end
end
