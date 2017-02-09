FactoryGirl.define do
  factory :person, :class => 'Person' do
    first_name "Fred"
    last_name "Smith"
    born_on "1965-01-01"
    gender :male
    password "password123"
    password_confirmation "password123"
    sequence(:email){|n| "me#{n}@example.com"}
    phone_number "4155551212"
  
    trait :admin do
      first_name "Admin"
      last_name "Admin"
      sequence(:email){|n| "admin#{n}@example.com"}
      role :admin
    end

    trait :coach do
      first_name "Sue"
      last_name "Admin"
      sequence(:email){|n| "sue_admin#{n}@example.com"}
      role :orgs_manager
    end
  end
end
