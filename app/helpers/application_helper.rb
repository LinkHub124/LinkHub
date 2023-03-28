module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'LinkHub'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def full_description(page_description = '')
    base_description = 'LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。'
    if page_description.empty?
      "#{base_description} "

    else
      base_description
    end
  end

  # def og_description(page_description = '')
  #   base_description = "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。"
  #   if page_description.empty?
  #     base_description
  #   else
  #     base_description
  #   end
  # end

  # def og_image(page_image = '')
  #   base_image = "LinkHub.jpg"
  #   if page_image.empty?
  #     base_image
  #   else
  #     base_image
  #   end
  # end
end
