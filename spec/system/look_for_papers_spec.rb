require 'rails_helper'

RSpec.describe '投稿機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
    @look_for_paper = FactoryBot.create(:look_for_paper, user_id: @user.id)
    @user_mission3 = UserMission.create(user_id: @user.id, mission_id: 3, completed: false)
  end

  describe '閲覧機能' do
    context '閲覧できるとき' do
      it '投稿した自分の探したい論文を閲覧できる' do
        sign_in(@user)
        find('a', text: '探したい論文').click
        expect(page).to have_current_path(look_for_paper_path(@user))
        expect(page).to have_content(@look_for_paper.look_for_paper)
        expect(page).to have_content(@look_for_paper.journal)
        expect(page).to have_content(@look_for_paper.search_word)
      end
    end
    context '閲覧できないとき' do
      it '他人の探したい論文は閲覧できない' do
        sign_in(@another_user)
        find('a', text: '探したい論文').click
        expect(page).to have_current_path(look_for_paper_path(@another_user))
        expect(page).to have_no_content(@look_for_paper.look_for_paper)
        expect(page).to have_no_content(@look_for_paper.journal)
        expect(page).to have_no_content(@look_for_paper.search_word)
      end
    end
  end

  describe '投稿機能' do
    context '投稿できるとき' do
      it '探したい論文があれば投稿できる' do
        sign_in(@user)
        find('a', text: '探したい論文').click
        fill_in 'look_for_paper_look_for_paper', with: 'test'
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { LookForPaper.count }.by(1)
        expect(page).to have_current_path(look_for_paper_path(@user))
        expect(page).to have_content('test')
      end
    end
    context '投稿できないとき' do
      it '空では投稿できない' do
        sign_in(@user)
        find('a', text: '探したい論文').click
        fill_in 'look_for_paper_look_for_paper', with: ''
        expect do
          find('input[name="commit"]').click
          sleep 1
        end.to change { LookForPaper.count }.by(0)
        expect(page).to have_current_path(look_for_paper_path(@user))
      end
    end
  end

  describe 'ミッション機能' do
    context 'ミッション達成されるとき' do
      it 'look_for_paperが投稿されるとミッション3が達成される' do
        sign_in(@user)
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission3.mission.description)
        find('a', text: '探したい論文').click
        fill_in 'look_for_paper_look_for_paper', with: 'test'
        find('input[name="commit"]').click
        find('a', text: 'マイページ').click
        expect(page).to have_no_content(@user_mission3.mission.description)
      end
    end
    context 'ミッション達成されないとき' do
      it 'Rallyの投稿に失敗するとミッション3は達成されない' do
        sign_in(@user)
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission3.mission.description)
        find('a', text: '探したい論文').click
        fill_in 'look_for_paper_look_for_paper', with: ''
        find('input[name="commit"]').click
        find('a', text: 'マイページ').click
        expect(page).to have_content(@user_mission3.mission.description)
      end
    end
  end
end
