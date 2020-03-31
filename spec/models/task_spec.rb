
require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#create' do
    let(:task){ build :task}
    it "has a valid factory" do
      expect(task).to be_valid
    end
  end
end
