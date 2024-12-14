require 'rails_helper'

RSpec.describe '投稿機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @paper_stock = FactoryBot.create(:paper_stock, user_id: @user.id)
    @user_mission4 = UserMission.create(user_id: @user.id, mission_id: 4, completed: false)
  end

  describe '閲覧機能' do
    context '閲覧できるとき' do
      it '投稿した論文ストックを閲覧できる' do
        sign_in(@user)
        find('a', text: '論文ストック').click
        expect(page).to have_current_path(paper_stock_path(@user))
        expect(page).to have_content(@paper_stock.outline)
        expect(page).to have_content(@paper_stock.paper_url)
      end
    end
    context '閲覧できないとき' do
      it '他人の論文ストックは閲覧できない' do
        sign_in(@another_user)
        find('a', text: '論文ストック').click
        expect(page).to have_current_path(paper_stock_path(@another_user))
        expect(page).to have_no_content(@paper_stock.outline)
        expect(page).to have_no_content(@paper_stock.paper_url)
      end
    end
  end

  describe '投稿機能' do
    context '投稿できるとき' do
      it '概要とURLがあれば投稿できる' do
        sign_in(@user)
        find('a', text: '論文ストック').click
        fill_in 'paper_stock_outline', with: 'test_outline'
        fill_in 'paper_stock_paper_url', with: 'test_url'
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { PaperStock.count }.by(1)
        expect(page).to have_current_path(paper_stock_path(@user))
        expect(page).to have_content('test_outline')
        expect(page).to have_content('test_url')
      end
    end
    context '投稿できないとき' do
      it '空では投稿できない' do
        sign_in(@user)
        find('a', text: '論文ストック').click
        fill_in 'paper_stock_outline', with: ''
        fill_in 'paper_stock_paper_url', with: ''
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { PaperStock.count }.by(0)
        expect(page).to have_current_path(paper_stock_path(@user))
      end
    end
  end

  describe 'ミッション機能' do
    context 'ミッション達成されるとき' do
      it 'look_for_paperが投稿されるとミッション4が達成される' do
        sign_in(@user)
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission4.mission.description)
        find('a', text: '論文ストック').click
        fill_in 'paper_stock_outline', with: 'test_outline'
        fill_in 'paper_stock_paper_url', with: 'test_url'
        find('input[name="commit"]').click
        find('a', text: 'マイページ').click
        expect(page).to have_no_content(@user_mission4.mission.description)
      end
    end
    context 'ミッション達成されないとき' do
      it 'Rallyの投稿に失敗するとミッション4は達成されない' do
        sign_in(@user)
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission4.mission.description)
        find('a', text: '論文ストック').click
        fill_in 'paper_stock_outline', with: ''
        fill_in 'paper_stock_paper_url', with: ''
        find('input[name="commit"]').click
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission4.mission.description)
      end
    end
  end
end
