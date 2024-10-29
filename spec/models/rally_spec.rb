require 'rails_helper'

RSpec.describe Rally, type: :model do
  before do
    @rally = FactoryBot.build(:rally, method: Faker::Lorem.paragraph)
  end

  describe 'Rally新規投稿' do
    context '新規投稿できるとき' do
      it 'すべての情報が存在すれば投稿できる' do
        expect(@rally).to be_valid
      end
      it 'backgroundが空でも投稿できる' do
        @rally.background = ''
        expect(@rally).to be_valid
      end
      it 'ideaが空でも投稿できる' do
        @rally.idea = ''
        expect(@rally).to be_valid
      end
      it 'methodが空でも投稿できる' do
        @rally.method = ''
        expect(@rally).to be_valid
      end
      it 'resultが空でも投稿できる' do
        @rally.result = ''
        expect(@rally).to be_valid
      end
      it 'discussionが空でも投稿できる' do
        @rally.discussion = ''
        expect(@rally).to be_valid
      end
    end
    context '新規投稿できないとき' do
      it 'userが紐づいていないと投稿できない' do
        @rally.user = nil
        @rally.valid?
        expect(@rally.errors.full_messages).to include('User must exist')
      end
      it 'titleが空では投稿できない' do
        @rally.title = ''
        @rally.valid?
        expect(@rally.errors.full_messages).to include("Title can't be blank")
      end
      it 'abstractが空では投稿できない' do
        @rally.abstract = ''
        @rally.valid?
        expect(@rally.errors.full_messages).to include("Abstract can't be blank")
      end
      it 'conclusionが空では投稿できない' do
        @rally.conclusion = ''
        @rally.valid?
        expect(@rally.errors.full_messages).to include("Conclusion can't be blank")
      end
      it 'opinionが空では投稿できない' do
        @rally.opinion = ''
        @rally.valid?
        expect(@rally.errors.full_messages).to include("Opinion can't be blank")
      end
      it 'URLが空では投稿できない' do
        @rally.url = ''
        @rally.valid?
        expect(@rally.errors.full_messages).to include("Url can't be blank")
      end
    end
  end
end
