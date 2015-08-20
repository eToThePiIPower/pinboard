FactoryGirl.define do
  factory :pin do |f|
    f.association :user
    f.title { Faker::Book.title }
    f.description { Faker::Lorem.sentence }
  end

  factory :invalid_pin, parent: :pin do |f|
    f.association :user
    f.title nil
  end
end
