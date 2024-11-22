require 'rails_helper'

RSpec.describe '新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context '新規登録できるとき' do
    it 'すべての情報が正確であれば登録できる' do
      visit(root_path)
      expect(page).to have_content('Sign up')
      visit(new_user_registration_path)
      fill_in 'Name', with: @user.name
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password
      expect do
        find('input[name="commit"]').click
        sleep 1
      end.to change { User.count }.by(1)
      expect(page).to have_current_path(root_path)
    end
  end
  context '新規登録できないとき' do
    it '誤った情報では登録できない' do
      visit(root_path)
      expect(page).to have_content('Sign up')
      visit(new_user_registration_path)
      fill_in 'Name', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      expect do
        find('input[name="commit"]').click
        sleep 1
      end.to change { User.count }.by(0)
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end

RSpec.describe 'ログイン・ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  describe 'ログイン' do
    context 'ログインできるとき' do
      it 'すべての情報が正確であればログインできる' do
        visit(root_path)
        expect(page).to have_content('Log in')
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        find('input[name="commit"]').click
        expect(page).to have_current_path(root_path)
      end
      context 'ログインできない' do
        it '誤った情報ではログインできない' do
          visit(root_path)
          expect(page).to have_content('Log in')
          fill_in 'Email', with: ''
          fill_in 'Password', with: ''
          find('input[name="commit"]').click
          expect(page).to have_current_path(new_user_session_path)
        end
      end
    end
  end
  describe 'ログアウト' do
    it 'ログアウトできる' do
      sign_in(@user)
      visit(user_path(@user))
      expect(page).to have_content('ログアウト')
      find('a', text: 'ログアウト').click
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end

RSpec.describe 'マイページ' do
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false, user_id: @user.id)
    @user_mission = FactoryBot.create(:user_mission, completed: false, user_id: @user.id)
    @user_mission_completed = FactoryBot.create(:user_mission, completed: true, user_id: @user.id)
  end
  it 'マイページの確認' do
    sign_in(@user)
    visit(user_path(@user))
    expect(page).to have_content('マイページ')
    expect(page).to have_content('ログアウト')
    expect(page).to have_content(@rally.title)
    expect(page).to have_content(@user_mission.mission.description)
    expect(page).to have_content('1')
  end
end
