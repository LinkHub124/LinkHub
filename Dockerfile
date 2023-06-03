FROM ruby:2.7.8
# ベースにするイメージを指定

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client vim
# RailsのインストールやMySQLへの接続に必要なパッケージをインストール

RUN mkdir /LinkHub-Backend
# コンテナ内にLinkHub-Backendディレクトリを作成

WORKDIR /LinkHub-Backend
# 作成したLinkHub-Backendディレクトリを作業用ディレクトリとして設定

COPY Gemfile /LinkHub-Backend/Gemfile
COPY Gemfile.lock /LinkHub-Backend/Gemfile.lock
# ローカルの Gemfile と Gemfile.lock をコンテナ内のLinkHub-Backend配下にコピー

RUN bundle install
# コンテナ内にコピーした Gemfile の bundle install

COPY . /LinkHub-Backend
# ローカルのLinkHub-Backend配下のファイルをコンテナ内のLinkHub-Backend配下にコピー