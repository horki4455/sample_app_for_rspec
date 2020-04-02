FactoryBot.define do
  factory :task do
    title { "hoge" }
    initialize_with { Task.find_or_create_by(title: title)}
    status { :doing }
  end
end
