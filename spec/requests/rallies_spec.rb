require 'rails_helper'

describe RalliesController, type: :request do
  include Devise::Test::IntegrationHelpers
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, method: Faker::Lorem.sentence, user_id: @user.id, draft: false)
    @comment = FactoryBot.create(:comment, rally_id: @rally.id)
    @user_mission1 = UserMission.create(user_id: @user.id, mission_id: 1, completed: false)
    @user_mission5 = UserMission.create(user_id: @user.id, mission_id: 5, completed: false)
    sign_in @user
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do
      get rallies_path
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みのrallyが必要な情報とともに存在する' do
      get rallies_path
      expect(response.body).to include(@rally.title)
      expect(response.body).to include(@rally.abstract)
      expect(response.body).to include(@rally.opinion)
      expect(response.body).to include(@rally.user.name)
    end
  end
  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get rally_path(@rally)
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのrallyが必要な情報とともに存在する' do
      get rally_path(@rally)
      expect(response.body).to include(@rally.title)
      expect(response.body).to include(@rally.abstract)
      expect(response.body).to include(@rally.background)
      expect(response.body).to include(@rally.idea)
      expect(response.body).to include(@rally.method)
      expect(response.body).to include(@rally.result)
      expect(response.body).to include(@rally.discussion)
      expect(response.body).to include(@rally.conclusion)
      expect(response.body).to include(@rally.opinion)
      expect(response.body).to include(@rally.url)
      expect(response.body).to include(@rally.user.name)
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのコメントと投稿フォームが存在する' do
      get rally_path(@rally)
      expect(response.body).to include(@comment.content)
      expect(response.body).to include('コメントする')
    end
  end
  describe 'GET #edit' do
    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      get edit_rally_path(@rally)
      expect(response.status).to eq 200
    end
    it 'editアクションにリクエストするとレスポンスに投稿済みのrallyが必要な情報とともに存在する' do
      get rally_path(@rally)
      expect(response.body).to include(@rally.title)
      expect(response.body).to include(@rally.abstract)
      expect(response.body).to include(@rally.background)
      expect(response.body).to include(@rally.idea)
      expect(response.body).to include(@rally.method)
      expect(response.body).to include(@rally.result)
      expect(response.body).to include(@rally.discussion)
      expect(response.body).to include(@rally.conclusion)
      expect(response.body).to include(@rally.opinion)
      expect(response.body).to include(@rally.url)
      expect(response.body).to include(@rally.user.name)
    end
    it 'editアクションにリクエストするとレスポンスに各ボタンが存在する' do
      get edit_rally_path(@rally)
      expect(response.body).to include('更新する')
      expect(response.body).to include('下書きに戻す')
      expect(response.body).to include('削除する')
    end
  end
  describe 'PUT #update' do
    it 'updateアクションにリクエストすると正常にレスポンスが返ってくる' do
      put rally_path(@rally), params: { rally: @rally.attributes }
      expect(response).to have_http_status(:found)
    end
    it 'updateアクションに不適切なパラメータを送るとレンダリングされる' do
      put rally_path(@rally), params: { rally: { title: '' } }
      expect(response.status).to eq 422
      expect(response).to render_template(:edit)
    end
    it '「更新する」ボタンを押すとdraftがfalseになる' do
      put rally_path(@rally), params: { rally: @rally.attributes, publish: true }
      @rally.reload
      expect(@rally.draft).to be false
    end
    it '「下書きに戻す」ボタンを押すとdraftがtrueになる' do
      put rally_path(@rally), params: { rally: @rally.attributes, save_as_draft: true }
      @rally.reload
      expect(@rally.draft).to be true
    end
  end
  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      get new_rally_path
      expect(response.status).to eq 200
    end
    it 'newアクションにリクエストするとレスポンスに各フォームが存在する' do
      get new_rally_path
      expect(response.body).to include('タイトル')
      expect(response.body).to include('要約')
      expect(response.body).to include('背景')
      expect(response.body).to include('アイデア')
      expect(response.body).to include('手法')
      expect(response.body).to include('結果')
      expect(response.body).to include('議論')
      expect(response.body).to include('結論')
      expect(response.body).to include('意見')
      expect(response.body).to include('Url')
    end
  end
  describe 'POST #create' do
    it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do
      post rallies_path, params: { rally: { title: 'test', abstract: 'test', conclusion: 'test', opinion: 'test', url: 'test' } }
      expect(response).to have_http_status(:found)
    end
    it 'createアクションに不適切なパラメータを送るとレンダリングされる' do
      post rallies_path, params: { rally: { title: '' } }
      expect(response.status).to eq 422
      expect(response).to render_template(:new)
    end
    it '「投稿する」ボタンを押すとdraftがfalseになる' do
      post rallies_path, params: { rally: @rally.attributes, publish: true }
      created_rally = assigns(:rally)
      expect(created_rally.draft).to be false
    end
    it '「保存する」ボタンを押すとdraftがtrueになる' do
      post rallies_path, params: { rally: @rally.attributes, save_as_draft: true }
      created_rally = assigns(:rally)
      expect(created_rally.draft).to be true
    end
  end
  describe 'DELETE #destroy' do
    it 'destroyアクションにリクエストすると正常にレスポンスが返ってくる' do
      delete rally_path(@rally)
      expect(response).to have_http_status(:found)
    end
  end
  describe 'GET #rally_lists' do
    it 'rally_listsアクションにリクエストすると正常にレスポンスが返ってくる' do
      get rally_lists_rallies_path(@user)
      expect(response.status).to eq 200
    end
    it 'rally_listsアクションにリクエストするとレスポンスに投稿済みのrallyと下書きのrallyが存在する' do
      rally_draft = FactoryBot.create(:rally, method: Faker::Lorem.sentence, user_id: @user.id, draft: true)
      get rally_lists_rallies_path(@user)
      expect(response.body).to include(@rally.title)
      expect(response.body).to include(rally_draft.title)
    end
  end
  describe 'GET #ranking' do
    it 'rankingアクションにリクエストすると正常にレスポンスが返ってくる' do
      get ranking_rallies_path(@user)
      expect(response.status).to eq 200
    end
  end

  describe 'mission1' do
    it 'マイページにリクエストするとレスポンスにミッション1が存在する' do
      get user_path(@user)
      expect(response.body).to include(@user_mission1.mission.description)
    end
    it 'Rallyを投稿するとcompletedがtrueになり、ミッション1はマイページに存在しなくなる' do
      post rallies_path, params: { rally: @rally.attributes, publish: true }
      get user_path(@user)
      expect(response.body).not_to include(@user_mission1.mission.description)
    end
  end
  describe 'mission5' do
    it 'マイページにリクエストするとレスポンスにミッション5が存在する' do
      get user_path(@user)
      expect(response.body).to include(@user_mission5.mission.description)
    end
    it 'Rallyを投稿するとcompletedがtrueになり、ミッション5はマイページに存在しなくなる' do
      put rally_path(@rally), params: { rally: @rally.attributes, publish: true }
      get user_path(@user)
      expect(response.body).not_to include(@user_mission5.mission.description)
    end
  end
end
