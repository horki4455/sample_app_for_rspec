FactoryBot.define do
  factory :task do
    title { "hoge" }
    status { :doing }
    user
  end
end
