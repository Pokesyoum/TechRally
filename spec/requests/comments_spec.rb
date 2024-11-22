require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  include Devise::Test::IntegrationHelpers
  before do
    @user = FactoryBot.create(:user)
    @rally = FactoryBot.create(:rally, draft: false)
    sign_in @user
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      it 'コメントが作成される' do
        expect do
          post rally_comments_path(@rally), params: { comment: { content: 'test', user_id: @user.id, rally_id: @rally.id } }
        end.to change(Comment, :count).by(1)
      end

      it '指定されたラリーにリダイレクトされる' do
        post rally_comments_path(@rally), params: { comment: { content: 'test', user_id: @user.id, ally_id: @rally.id } }
        expect(response).to redirect_to("/rallies/#{@rally.id}")
      end
    end

    context '無効なパラメータの場合' do
      it 'コメントは作成されない' do
        expect do
          post rally_comments_path(@rally), params: { comment: { content: '', user_id: @user.id, rally_id: @rally.id } }
        end.not_to change(Comment, :count)
      end
    end
  end
end