
require 'rails_helper'
describe Task do
  describe '#create' do
    it "バリデーション" do

     task = Task.new(title: nil, status: nil)

    expect(task.valid?).to eq(false)
    end
  end
end
