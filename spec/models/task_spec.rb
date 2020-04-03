
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#create' do
    let(:task){ create :task}

    it 'is valid with all attributes' do
      expect(task).to be_valid
    end

    it 'is invalid without title' do
      task = Task.new(title: nil)
      expect(task).to be_invalid
    end

    it 'is invalid without status' do
      task = Task.new(status: nil)
      expect(task).to be_invalid
    end

    it 'is valid with another title' do
      @another_task = Task.create(title: 'hoge2', status: :doing)
      expect(@another_task).to be_valid
    end

    it "is invalid with a duplicate title" do
      Task.create(
        title: 'hoge',
        status: :doing
      )
      task = Task.new(
        title: 'hoge',
        status: :doing
      )
      expect(task).to be_invalid
    end
  end
end
