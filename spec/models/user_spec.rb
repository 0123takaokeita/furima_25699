require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  context '保存できるとき' do
    it 'すべての入力がされている'do
      expect(@user).to be_valid
    end

  end
  context '保存できないとき' do
    it 'たかお'do
    end
    it 'つるさかい'do
    end    
  end
end
