require 'rails_helper'

RSpec.describe LookForPapersController, type: :request do
  include Devise::Test::IntegrationHelpers
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false)
    @look_for_paper = FactoryBot.create(:look_for_paper, user_id: @user.id)
    @user_mission3 = UserMission.create(user_id: @user.id, mission_id: 3, completed: false)
    sign_in @user
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get look_for_paper_path(@user)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みのlook_for_paperが存在する' do
      get look_for_paper_path(@user)
      expect(response.body).to include(@look_for_paper.look_for_paper)
      expect(response.body).to include(@look_for_paper.journal)
      expect(response.body).to include(@look_for_paper.search_word)
    end

    it 'showアクションにリクエストするとレスポンスにlook_for_paperのフォームが存在する' do
      get look_for_paper_path(@user)
      expect(response.body).to include('探したい論文')
      expect(response.body).to include('ジャーナル')
      expect(response.body).to include('検索ワード')
    end
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      it 'look_for_paperが作成される' do
        expect do
          post look_for_papers_path(@user), params: { look_for_paper: { look_for_paper: 'test', user_id: @user.id } }
        end.to change(LookForPaper, :count).by(1)
      end

      it 'look_for_paperにリダイレクトされる' do
        post look_for_papers_path(@user), params: { look_for_paper: { look_for_paper: 'test', user_id: @user.id } }
        expect(response).to redirect_to(look_for_paper_path(@user))
      end
    end

    context '無効なパラメータの場合' do
      it 'look_for_paperは作成されない' do
        expect do
          post look_for_papers_path(@user), params: { look_for_paper: { look_for_paper: '', user_id: @user.id } }
        end.not_to change(LookForPaper, :count)
      end
    end
  end

  describe 'mission3' do
    it 'マイページにリクエストするとレスポンスにミッション3が存在する' do
      get user_path(@user)
      expect(response.body).to include(@user_mission3.mission.description)
    end
    it 'look_for_paperを投稿するとcompletedがtrueになり、ミッション3はマイページに存在しなくなる' do
      post look_for_papers_path(@user), params: { look_for_paper: { look_for_paper: 'test', user_id: @user.id } }
      get user_path(@user)
      expect(response.body).not_to include(@user_mission3.mission.description)
    end
  end
end
