require 'rails_helper'

RSpec.describe '投稿機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.build(:rally, user_id: @user.id)
  end

  describe '新規作成' do
    context '新規作成できるとき' do
      it '必要な情報があれば投稿できる' do
        sign_in(@user)
        find('a', text: '投稿する').click
        find('a', text: '新規投稿').click
        fill_in 'rally_title', with: @rally.title
        fill_in 'rally_abstract', with: @rally.abstract
        fill_in 'rally_conclusion', with: @rally.conclusion
        fill_in 'rally_opinion', with: @rally.opinion
        fill_in 'rally_url', with: @rally.url
        expect do
          find('input[name="publish"]').click
          sleep 1
        end.to change { Rally.count }.by(1)
        expect(page).to have_current_path(rally_lists_rallies_path)
        posted_container = find('.posted-rallies-container')
        expect(posted_container).to have_content(@rally.title)
      end
      it '必要な情報があれば下書きに保存できる' do
        sign_in(@user)
        find('a', text: '投稿する').click
        find('a', text: '新規投稿').click
        fill_in 'rally_title', with: @rally.title
        fill_in 'rally_abstract', with: @rally.abstract
        fill_in 'rally_conclusion', with: @rally.conclusion
        fill_in 'rally_opinion', with: @rally.opinion
        fill_in 'rally_url', with: @rally.url
        expect do
          find('input[name="save_as_draft"]').click
          sleep 1
        end.to change { Rally.count }.by(1)
        expect(page).to have_current_path(rally_lists_rallies_path)
        saved_container = find('.saved-rallies-container')
        expect(saved_container).to have_content(@rally.title)
      end
    end
    context '新規作成できないとき' do
      it '必要な情報がないと投稿できない' do
        sign_in(@user)
        find('a', text: '投稿する').click
        find('a', text: '新規投稿').click
        fill_in 'rally_title', with: ''
        expect do
          find('input[name="publish"]').click
          sleep 1
        end.to change { Rally.count }.by(0)
        expect(page).to have_current_path(new_rally_path)
      end
    end
  end
end

RSpec.describe '閲覧・コメント機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false)
    @comment = FactoryBot.build(:comment)
  end

  describe '投稿済みrallyの閲覧' do
    it 'トップページに投稿済みのrallyが表示される' do
      sign_in(@user)
      expect(page).to have_content(@rally.title)
      expect(page).to have_content(@rally.abstract)
      expect(page).to have_content(@rally.opinion)
      expect(page).to have_content(@rally.user.name)
    end
    it 'rallyのタイトルをクリックすると詳細が閲覧できる' do
      sign_in(@user)
      find('a', text: @rally.title).click
      expect(page).to have_current_path(rally_path(@rally))
      expect(page).to have_content(@rally.title)
      expect(page).to have_content(@rally.abstract)
      expect(page).to have_content(@rally.background)
      expect(page).to have_content(@rally.idea)
      expect(page).to have_content(@rally.result)
      expect(page).to have_content(@rally.discussion)
      expect(page).to have_content(@rally.conclusion)
      expect(page).to have_content(@rally.opinion)
      expect(page).to have_content(@rally.url)
      expect(page).to have_content(@rally.user.name)
    end
  end
  describe 'コメント機能' do
    context '新規投稿できるとき' do
      it 'rallyの詳細画面からコメントを投稿できる' do
        sign_in(@user)
        find('a', text: @rally.title).click
        fill_in 'comment_content', with: @comment.content
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { Comment.count }.by(1)
        expect(page).to have_current_path(rally_path(@rally))
        expect(page).to have_content(@comment.content)
      end
    end
    context '新規投稿できないとき' do
      it '空ではコメントを投稿できない' do
        sign_in(@user)
        find('a', text: @rally.title).click
        fill_in 'comment_content', with: ''
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { Comment.count }.by(0)
        expect(page).to have_current_path(rally_path(@rally))
      end
    end
  end
end

RSpec.describe '編集・削除機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false, user_id: @user.id)
  end

  describe 'rally編集機能' do
    context '編集できるとき' do
      it 'rallyの投稿者は編集できる' do
        sign_in(@user)
        find('a', text: @rally.title).click
        find('a', text: '編集する').click
        expect(page).to have_current_path(edit_rally_path(@rally))
        fill_in 'rally_title', with: 'test'
        find('input[name="publish"]').click
        expect(page).to have_current_path(rally_lists_rallies_path)
        posted_container = find('.posted-rallies-container')
        expect(posted_container).to have_content('test')
      end
    end
    context '編集できないとき' do
      it '必要な情報を空にはできない' do
        sign_in(@user)
        find('a', text: @rally.title).click
        find('a', text: '編集する').click
        expect(page).to have_current_path(edit_rally_path(@rally))
        fill_in 'rally_title', with: ''
        find('input[name="publish"]').click
        expect(page).to have_current_path(edit_rally_path(@rally))
      end
      it 'rallyの投稿者でないと編集できない' do
        sign_in(@user2)
        find('a', text: @rally.title).click
        expect(page).to have_no_content('編集する')
      end
    end
  end
  describe 'rally削除機能' do
    context '削除できるとき' do
      it 'rallyの投稿者は削除できる' do
        sign_in(@user)
        find('a', text: @rally.title).click
        find('a', text: '編集する').click
        expect(page).to have_current_path(edit_rally_path(@rally))
        find('a', text: '削除する').click
        expect(page).to have_current_path(rally_lists_rallies_path)
        expect(page).to have_no_content(@rally.title)
      end
    end
    context '削除できないとき' do
      it 'rallyの投稿者でないと削除できない' do
        sign_in(@user2)
        find('a', text: @rally.title).click
        expect(page).to have_no_content('編集する')
      end
    end
  end
end

RSpec.describe 'ランキング機能', type: :system do
  before do
    @user = FactoryBot.create(:user, name: 'user')
    @user2 = FactoryBot.create(:user, name: 'user2')

    @rally = FactoryBot.create(:rally, draft: false, user_id: @user.id)
    @rally2 = FactoryBot.create(:rally, draft: false, user_id: @user.id)
    @rally_user2 = FactoryBot.create(:rally, draft: false, user_id: @user2.id)

    @comment = FactoryBot.create(:comment, user_id: @user.id)
    @comment2 = FactoryBot.create(:comment, user_id: @user.id)
    @comment_user2 = FactoryBot.create(:comment, user_id: @user2.id)
  end

  it 'ランキングが正しく表示される' do
    sign_in(@user)
    find('a', text: 'ランキング').click
    expect(page).to have_content('1位: user, 投稿したRally数: 2')
    expect(page).to have_content('1位: user, コメント数: 2')
  end
end
