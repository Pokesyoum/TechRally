require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント新規投稿' do
    context '新規投稿できるとき' do
      it 'すべての情報があれば投稿できる' do
        expect(@comment).to be_valid
      end
    end
    context '新規投稿できないとき' do
      it 'userが紐づいていないと投稿できない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('User must exist')
      end
      it 'rallyが紐づいていないと投稿できない' do
        @comment.rally = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('Rally must exist')
      end
      it 'contentが空だと投稿できない' do
        @comment.content = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Content can't be blank")
      end
    end
  end
end
