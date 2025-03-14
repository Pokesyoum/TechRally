# アプリケーション名
Tech Rally

# アプリケーション概要
想定ユーザー：企業の開発職チーム

自分の読んだ論文などの技術資料をXやTeamsのようにチーム内で共有できるアプリ。ゲーミフィケーションの要素を取り入れ、技術情報収集を習慣化する仕組みを実装した。

# URL
https://techrally.onrender.com

# テスト用アカウント
・Basic認証ID：admin<br>
・Basic認証パスワード：2222<br>
・メールアドレス：sample2@email.com<br>
・パスワード：sample2

# 利用方法(実装した機能)
## Rally投稿
Rally：論文の要約などをユーザーがまとめたもの
1. サイドバーの「投稿する」から投稿ページへ移動する。
2. 右上の「新規投稿」ボタンから投稿フォームへ移動し、各項目（タイトル、要約、意見、URLは必須）を埋めて「投稿する」をクリックする。下書き（非公開）で保存することも可能。

[![Image from Gyazo](https://i.gyazo.com/e380be5fc9cce9b00aa874ab636f0d2b.gif)](https://gyazo.com/e380be5fc9cce9b00aa874ab636f0d2b)

## コメント機能
1. トップページからRallyを選択し、詳細画面へ移動する。
2. Rally下部のコメント欄にコメントを記載し、「投稿ボタン」をクリック。

[![Image from Gyazo](https://i.gyazo.com/9768dd5cdbe0fc8295e1d47c81cb01a4.gif)](https://gyazo.com/9768dd5cdbe0fc8295e1d47c81cb01a4)

## ミッション機能
1. マイページから保有しているミッション（最大3つ）を確認できる。
2. ミッションに記載されているアクションを取ることでミッションを達成できる。

[![Image from Gyazo](https://i.gyazo.com/c82fe5c921067efa003e552736b07011.gif)](https://gyazo.com/c82fe5c921067efa003e552736b07011)

## ランキング機能
ランキングページから、Rallyの投稿数、コメントの投稿数、ミッションの達成数のランキングが確認できる。チーム内で競い合ったり、コミュニケーションのきっかけになることを想定している。

[![Image from Gyazo](https://i.gyazo.com/6f15e624e26ccce01043e127292fd57d.png)](https://gyazo.com/6f15e624e26ccce01043e127292fd57d)

## 探したい論文機能
探したい論文の特徴や検索ワードをメモしておく機能。
1. サイドバーの「探したい論文」から専用ページへ移動する。
2. 画面右のフォームに入力して「保存する」ボタンをクリック。

[![Image from Gyazo](https://i.gyazo.com/a3ff12d0a2e719a4bdd97bb31822d22f.gif)](https://gyazo.com/a3ff12d0a2e719a4bdd97bb31822d22f)

## 論文ストック機能
読みたい論文をストックしておく機能。
1. サイドバーの「論文ストック」から専用ページへ移動する。
2. 画面右のフォームに入力して「保存する」ボタンをクリック。

[![Image from Gyazo](https://i.gyazo.com/2430773cebf9eb4eb17e58d6d7efb13b.gif)](https://gyazo.com/2430773cebf9eb4eb17e58d6d7efb13b)

# アプリケーションを作成した背景
企業の開発職として働いていた際、日頃から論文などの技術資料に触れ、知識習得・情報収集しておくことが重要であると感じる反面、習慣化する難しさを感じた。特にネタ探しやモチベーションの維持、時間の確保が課題として挙げられた。これらを解決するため、ミッションやランキングといったゲーム的な要素を取り入れ、楽しみながら学習できるようなアプリを開発することとした。ミッションはスキマ時間で達成できるように細分化したものを多数用意し、気づいた時には学習を習慣化できているようなアプリ設計を目指した。

# データベース設計
![alt text](database.png)

# 開発環境
・バックエンド：Ruby on Rails, PostgreSQL<br>
・フロントエンド：HTML5, CSS3<br>
・インフラ：Render<br>
・テスト：RSpec, Capybara, FactoryBot<br>
・テキストエディタ：Visual Studio Code

# ローカルでの動作方法
以下のコマンドを順に実行。<br>
% git clone https://github.com/Pokesyoum/TechRally<br>
% cd TechRally<br>
% bundle install<br>
% rails db:create<br>
% rails db:migrate

# 工夫したポイント
ただの投稿アプリではなくミッションやランキングなどのゲーム的な要素を取り入れたアプリとした点。ミッションには完了フラグがあり、ミッション内容に相当するアクションを実行した際に、完了フラグが立つよう設定した。

# 改善点
・投稿したコメントの編集・削除機能の追加実装。<br>
・whenever gemを使って毎日0時にミッションを配布する機能を実装したが、Render上では動作しないようなので、Renderのクーロンジョブ設定機能で実装し直す必要がある。

# 制作時間
1日の作業時間：1-3時間程度<br>
アプリの企画から実装：3週間<br>
テストコード：2週間