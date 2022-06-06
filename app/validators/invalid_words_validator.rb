class InvalidWordsValidator < ActiveModel::EachValidator

# record : テーブル名のこと(Micripostとか)
# attribute : カラム名（contentとか）
# value : フォームに入力された値（"おはよう","foobar"とか）
  def validate_each(record, attribute, value)
# blacklist.ymlから不適切な言葉を読み取る
    blacklist = YAML.load_file('./config/blacklist.yml')
# valueが空でないか、blacklistに入力された値が含まれているかを判断
    if value.present? && blacklist.any?{ |word| value.include?(word) }
# contain_blacklist_words "内容~"と出力したくなかったので第二引数を''としている。
#（あまりいい方法ではないかもしれません。）
# :contain_blacklist_wordsはja.ymlなどに定義しておくとよい。
      record.errors.add(:contain_blacklist_words,'')
    end

# same_character_regex: 連続する五文字以上の語（"あああああ"）などを防ぐ
# url_regex: https(http)から始まるurlを防ぐ
# html_regex: htmlタグを防ぐ

# 正規表現のエスケープのため %r!正規表現!で囲む
#
    invalid_regex = { same_character_regex: %r!(.)\1{4,}!,
                      url_regex: %r!https?://!,
                      html_regex: %r!<("|.*?|'.*?'|[^'"])*?>!}
# invalid_regexをinvalid_key,invalid_valueとして取り出しinvalid_value.match?(value)で正規表現と一致しているかを調べる。
    if value.present? && invalid_regex.any?{|invalid_key,invalid_value| invalid_value.match?(value)}
      record.errors.add(:contain_invalid_regex, '')
    end

  end

end
