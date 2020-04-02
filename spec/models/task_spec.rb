
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#create' do
    let(:task){ build :task}
    it 'is valid with all attributes' do
      expect(task).to be_valid
    end

    it 'is invalid without title' do
      @task = Task.new(title: nil)
      expect(@task.valid?).to eq(false)
    end

    it 'is invalid without status' do
      @task = Task.new(status: nil)
      expect(@task.valid?).to eq(false)
    end

    it 'is valid with another title' do
      @task = Task.create(title: 'hoge2', status: :doing)
      expect(task).to be_valid
    end

    it "is invalid with a duplicate title" do
      Task.create(
        title: 'hoge',
        status: :doing
      )
      @task = Task.new(
        title: 'hoge',
        status: :doing
      )
      @task.valid?
      expect(@task.valid?).to eq(false)
    end
  end
end
