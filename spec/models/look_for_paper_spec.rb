require 'rails_helper'

RSpec.describe LookForPaper, type: :model do
  before do
    @look_for_paper = FactoryBot.build(:look_for_paper)
  end

  describe '探したい論文新規投稿' do
    context '新規投稿できるとき' do
      it 'すべての情報があれば投稿できる' do
        expect(@look_for_paper).to be_valid
      end
      it 'journalが空でも投稿できる' do
        @look_for_paper.journal = ''
        expect(@look_for_paper).to be_valid
      end
      it 'search_wordが空でも投稿できる' do
        @look_for_paper.search_word
        expect(@look_for_paper).to be_valid
      end
    end
    context '新規投稿できないとき' do
      it 'userが紐づいていないと投稿できない' do
        @look_for_paper.user = nil
        @look_for_paper.valid?
        expect(@look_for_paper.errors.full_messages).to include('User must exist')
      end
      it 'look_for_paperが空だと投稿できない' do
        @look_for_paper.look_for_paper = ''
        @look_for_paper.valid?
        expect(@look_for_paper.errors.full_messages).to include("Look for paper can't be blank")
      end
    end
  end
end
