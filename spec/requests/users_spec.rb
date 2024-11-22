require 'rails_helper'

describe UsersController, type: :request do
  include Devise::Test::IntegrationHelpers
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, user_id: @user.id, draft: false)
    @user_mission_true = FactoryBot.create(:user_mission, user_id: @user.id, completed: true)
    @user_mission_false = FactoryBot.create(:user_mission, user_id: @user.id, completed: false)
    sign_in @user
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get user_path(@user)
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みのrallyのタイトルが存在する' do
      get user_path(@user)
      expect(response.body).to include(@rally.title)
    end
    it 'showアクションにリクエストするとレスポンスに保有しているmissionが表示される' do
      get user_path(@user)
      expect(response.body).to include(@user_mission_false.mission.description)
    end
    it 'showアクションにリクエストするとレスポンスに達成したmission数が表示される' do
      get user_path(@user)
      expect(response.body).to include(UserMission.where(completed: true).count.to_s)
    end
  end
end
