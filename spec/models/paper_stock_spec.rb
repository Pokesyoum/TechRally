require 'rails_helper'

RSpec.describe PaperStock, type: :model do
  before do
    @paper_stock = FactoryBot.build(:paper_stock)
  end

  describe '論文ストック新規投稿' do
    context '新規投稿できるとき' do
      it 'すべての情報があれば投稿できる' do
        expect(@paper_stock).to be_valid
      end
    end
    context '新規投稿できないとき' do
      it 'userが紐づいていないと投稿できない' do
        @paper_stock.user = nil
        @paper_stock.valid?
        expect(@paper_stock.errors.full_messages).to include('User must exist')
      end
      it 'outlineが空だと投稿できない' do
        @paper_stock.outline = ''
        @paper_stock.valid?
        expect(@paper_stock.errors.full_messages).to include("Outline can't be blank")
      end
      it 'paper_urlが空だと投稿できない' do
        @paper_stock.paper_url = ''
        @paper_stock.valid?
        expect(@paper_stock.errors.full_messages).to include("Paper url can't be blank")
      end
    end
  end
end
