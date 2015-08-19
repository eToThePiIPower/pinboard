FactoryGirl.define do
  factory :pin do |f|
    f.title { Faker::Book.title }
    f.description { Faker::Lorem.sentence }
  end

  factory :invalid_pin, parent: :pin do |f|
    f.title nil
  end
end
