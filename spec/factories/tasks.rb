FactoryBot.define do
  factory :task do
    title { "hoge" }
    # sequence(:title) { |n| "hoge#{n}" }
    status { "doing" }
    initialize_with { Task.find_or_create_by(title: title)}
  end
end

# FactoryBot.define do
# factory :task, class: Task do
# title {‘hoge’}
# status {:doing}
# end
# end
