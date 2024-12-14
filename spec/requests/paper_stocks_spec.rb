require 'rails_helper'

RSpec.describe PaperStocksController, type: :request do
  include Devise::Test::IntegrationHelpers
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false)
    @paper_stock = FactoryBot.create(:paper_stock, user_id: @user.id)
    @user_mission4 = UserMission.create(user_id: @user.id, mission_id: 4, completed: false)
    sign_in @user
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get paper_stock_path(@user)
      expect(response.status).to eq 200
    end

    it 'showアクションにリクエストするとレスポンスに投稿済みのpaper_stockが存在する' do
      get paper_stock_path(@user)
      expect(response.body).to include(@paper_stock.outline)
      expect(response.body).to include(@paper_stock.paper_url)
    end

    it 'showアクションにリクエストするとレスポンスにpaper_stockのフォームが存在する' do
      get paper_stock_path(@user)
      expect(response.body).to include('論文の概要')
      expect(response.body).to include('Url')
    end
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      it 'paper_stockが作成される' do
        expect do
          post paper_stocks_path(@user), params: { paper_stock: { outline: 'test', paper_url: 'test', user_id: @user.id } }
        end.to change(PaperStock, :count).by(1)
      end

      it 'paper_stockにリダイレクトされる' do
        post paper_stocks_path(@user), params: { paper_stock: { outline: 'test', paper_url: 'test', user_id: @user.id } }
        expect(response).to redirect_to(paper_stock_path(@user))
      end
    end

    context '無効なパラメータの場合' do
      it 'paper_stockは作成されない' do
        expect do
          post paper_stocks_path(@user), params: { paper_stock: { outline: '', user_id: @user.id } }
        end.not_to change(PaperStock, :count)
      end
    end
  end

  describe 'mission4' do
    it 'マイページにリクエストするとレスポンスにミッション4が存在する' do
      get user_path(@user)
      expect(response.body).to include(@user_mission4.mission.description)
    end
    it 'look_for_paperを投稿するとcompletedがtrueになり、ミッション4はマイページに存在しなくなる' do
      post paper_stocks_path(@user), params: { paper_stock: { outline: 'test', paper_url: 'test', user_id: @user.id } }
      get user_path(@user)
      expect(response.body).not_to include(@user_mission4.mission.description)
    end
  end
end
