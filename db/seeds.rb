# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create(
    email: 'admin@example.com',
    name: 'admin',
    password: 'password',
    password_confirmation: 'password'
)

alice = User.create(
    email: 'nope124mailer+alice@gmail.com',
    name: 'Alice',
    password: 'password',
    password_confirmation: 'password',
    agreement: true,
    introduction: 'Aliceの自己紹介です。',
    github_id: 'alice_github',
    twitter_id: 'alice_twitter',
    facebook_id: 'alice_facebook',
    homepage_url: 'https://colink.jp',
    confirmed_at: Time.now.utc,
    confirmation_token: nil,
    is_admin: true
)

bob = User.create(
    email: 'nope124mailer+bob@gmail.com',
    name: 'Bob',
    password: 'password',
    password_confirmation: 'password',
    agreement: true,
    introduction: 'Bobの自己紹介です。',
    github_id: 'bob_github',
    twitter_id: 'bob_twitter',
    facebook_id: 'bob_facebook',
    homepage_url: 'https://google.com',
    confirmed_at: Time.now.utc,
    confirmation_token: nil
)

carol = User.create(
    email: 'nope124mailer+carol@gmail.com',
    name: 'Carol',
    password: 'password',
    password_confirmation: 'password',
    agreement: true,
    introduction: 'Carolの自己紹介です。',
    github_id: 'carol_github',
    twitter_id: 'carol_twitter',
    facebook_id: 'carol_facebook',
    homepage_url: 'https://google.com',
    confirmed_at: Time.now.utc,
    confirmation_token: nil
)

alice_theme_private = Theme.create(
    user_id: alice.id,
    title: "Aliceのテーマ/非公開",
    post_status: 0
)

alice_theme_limited = Theme.create(
    user_id: alice.id,
    title: "Aliceのテーマ/限定公開",
    post_status: 1
)

alice_theme_released = Theme.create(
    user_id: alice.id,
    title: "Aliceのテーマ/全体公開",
    post_status: 2
)

bob_theme_private = Theme.create(
    user_id: bob.id,
    title: "Bobのテーマ/非公開",
    post_status: 0
)

bob_theme_limited = Theme.create(
    user_id: bob.id,
    title: "Bobのテーマ/限定公開",
    post_status: 1
)

bob_theme_released = Theme.create(
    user_id: bob.id,
    title: "Bobのテーマ/全体公開",
    post_status: 2
)

carol_theme_private = Theme.create(
    user_id: carol.id,
    title: "Carolのテーマ/非公開",
    post_status: 0
)

carol_theme_limited = Theme.create(
    user_id: carol.id,
    title: "Carolのテーマ/限定公開",
    post_status: 1
)

carol_theme_released = Theme.create(
    user_id: carol.id,
    title: "Carolのテーマ/全体公開",
    post_status: 2
)

Relationship.create(
    followed_id: alice.id,
    follower_id: bob.id
)

Favorite.create(
    user_id: alice.id,
    theme_id: alice_theme_released.id
)

Favorite.create(
    user_id: alice.id,
    theme_id: bob_theme_released.id
)

Favorite.create(
    user_id: alice.id,
    theme_id: carol_theme_limited.id
)

Favorite.create(
    user_id: bob.id,
    theme_id: alice_theme_limited.id
)

Favorite.create(
    user_id: bob.id,
    theme_id: bob_theme_limited.id
)

Favorite.create(
    user_id: bob.id,
    theme_id: carol_theme_private.id
)

Favorite.create(
    user_id: carol.id,
    theme_id: alice_theme_private.id
)

Favorite.create(
    user_id: bob.id,
    theme_id: bob_theme_private.id
)

Favorite.create(
    user_id: bob.id,
    theme_id: carol_theme_released.id
)

alice_theme_private_link_1 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_private.id,
    subtitle: "Aliceのテーマ/非公開/リンク集1",
    caption: "Aliceのテーマ/非公開/リンク集1のキャプションです。"
)

alice_theme_private_link_2 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_private.id,
    subtitle: "Aliceのテーマ/非公開/リンク集2",
    caption: "Aliceのテーマ/非公開/リンク集2のキャプションです。"
)

alice_theme_private_link_3 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_private.id,
    subtitle: "Aliceのテーマ/非公開/リンク集3",
    caption: "Aliceのテーマ/非公開/リンク集3のキャプションです。"
)

alice_theme_limited_link_1 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_limited.id,
    subtitle: "Aliceのテーマ/限定公開/リンク集1",
    caption: "Aliceのテーマ/限定公開/リンク集1のキャプションです。"
)

alice_theme_limited_link_2 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_limited.id,
    subtitle: "Aliceのテーマ/限定公開/リンク集2",
    caption: "Aliceのテーマ/限定公開/リンク集2のキャプションです。"
)

alice_theme_limited_link_3 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_limited.id,
    subtitle: "Aliceのテーマ/限定公開/リンク集3",
    caption: "Aliceのテーマ/限定公開/リンク集3のキャプションです。"
)

alice_theme_released_link_1 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_released.id,
    subtitle: "Aliceのテーマ/全体公開/リンク集1",
    caption: "Aliceのテーマ/全体公開/リンク集1のキャプションです。"
)

alice_theme_released_link_2 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_released.id,
    subtitle: "Aliceのテーマ/全体公開/リンク集2",
    caption: "Aliceのテーマ/全体公開/リンク集2のキャプションです。"
)

alice_theme_released_link_3 = Link.create(
    user_id: alice.id,
    theme_id: alice_theme_released.id,
    subtitle: "Aliceのテーマ/全体公開/リンク集3",
    caption: "Aliceのテーマ/全体公開/リンク集3のキャプションです。"
)

bob_theme_private_link_1 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_private.id,
    subtitle: "Bobのテーマ/非公開/リンク集1",
    caption: "Bobのテーマ/非公開/リンク集1のキャプションです。"
)

bob_theme_private_link_2 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_private.id,
    subtitle: "Bobのテーマ/非公開/リンク集2",
    caption: "Bobのテーマ/非公開/リンク集2のキャプションです。"
)

bob_theme_private_link_3 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_private.id,
    subtitle: "Bobのテーマ/非公開/リンク集3",
    caption: "Bobのテーマ/非公開/リンク集3のキャプションです。"
)

bob_theme_limited_link_1 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_limited.id,
    subtitle: "Bobのテーマ/限定公開/リンク集1",
    caption: "Bobのテーマ/限定公開/リンク集1のキャプションです。"
)

bob_theme_limited_link_2 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_limited.id,
    subtitle: "Bobのテーマ/限定公開/リンク集2",
    caption: "Bobのテーマ/限定公開/リンク集2のキャプションです。"
)

bob_theme_limited_link_3 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_limited.id,
    subtitle: "Bobのテーマ/限定公開/リンク集3",
    caption: "Bobのテーマ/限定公開/リンク集3のキャプションです。"
)

bob_theme_released_link_1 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_released.id,
    subtitle: "Bobのテーマ/全体公開/リンク集1",
    caption: "Bobのテーマ/全体公開/リンク集1のキャプションです。"
)

bob_theme_released_link_2 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_released.id,
    subtitle: "Bobのテーマ/全体公開/リンク集2",
    caption: "Bobのテーマ/全体公開/リンク集2のキャプションです。"
)

bob_theme_released_link_3 = Link.create(
    user_id: bob.id,
    theme_id: bob_theme_released.id,
    subtitle: "Bobのテーマ/全体公開/リンク集3",
    caption: "Bobのテーマ/全体公開/リンク集3のキャプションです。"
)

carol_theme_private_link_1 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_private.id,
    subtitle: "Carolのテーマ/非公開/リンク集1",
    caption: "Carolのテーマ/非公開/リンク集1のキャプションです。"
)

carol_theme_private_link_2 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_private.id,
    subtitle: "Carolのテーマ/非公開/リンク集2",
    caption: "Carolのテーマ/非公開/リンク集2のキャプションです。"
)

carol_theme_private_link_3 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_private.id,
    subtitle: "Carolのテーマ/非公開/リンク集3",
    caption: "Carolのテーマ/非公開/リンク集3のキャプションです。"
)

carol_theme_limited_link_1 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_limited.id,
    subtitle: "Carolのテーマ/限定公開/リンク集1",
    caption: "Carolのテーマ/限定公開/リンク集1のキャプションです。"
)

carol_theme_limited_link_2 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_limited.id,
    subtitle: "Carolのテーマ/限定公開/リンク集2",
    caption: "Carolのテーマ/限定公開/リンク集2のキャプションです。"
)

carol_theme_limited_link_3 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_limited.id,
    subtitle: "Carolのテーマ/限定公開/リンク集3",
    caption: "Carolのテーマ/限定公開/リンク集3のキャプションです。"
)

carol_theme_released_link_1 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_released.id,
    subtitle: "Carolのテーマ/全体公開/リンク集1",
    caption: "Carolのテーマ/全体公開/リンク集1のキャプションです。"
)

carol_theme_released_link_2 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_released.id,
    subtitle: "Carolのテーマ/全体公開/リンク集2",
    caption: "Carolのテーマ/全体公開/リンク集2のキャプションです。"
)

carol_theme_released_link_3 = Link.create(
    user_id: carol.id,
    theme_id: carol_theme_released.id,
    subtitle: "Carolのテーマ/全体公開/リンク集3",
    caption: "Carolのテーマ/全体公開/リンク集3のキャプションです。"
)

OneLink.create(
    link_id: alice_theme_private_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: alice_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: bob_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_private_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_limited_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_1.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_2.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)

OneLink.create(
    link_id: carol_theme_released_link_3.id,
    url: "https://colink.jp",
    url_title: "LinkHub",
    url_description: "LinkHubはリンク集の共有をするサイトです。日常で得た知見、役立つ情報を他のユーザーたちと共有していきましょう。",
    url_image: "https://colink.jp/assets/LinkHub-e8ea72d713c39eee1c305ae3c780c6c1e2f3f9b6767b100aafc29bbb1227da45.jpg"
)