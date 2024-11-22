require 'rails_helper'

RSpec.describe UserMission, type: :model do
  before do
    @user_mission = FactoryBot.build(:user_mission)
  end

  describe 'ユーザーミッション新規登録' do
    context '新規登録できるとき' do
      it 'すべての情報が存在すれば登録できる' do
        expect(@user_mission).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'userが紐づいていないと投稿できない' do
        @user_mission.user = nil
        @user_mission.valid?
        expect(@user_mission.errors.full_messages).to include('User must exist')
      end
      it 'missionが紐づいていないと投稿できない' do
        @user_mission.mission = nil
        @user_mission.valid?
        expect(@user_mission.errors.full_messages).to include('Mission must exist')
      end
    end
  end
end
