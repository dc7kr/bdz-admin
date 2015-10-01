# This will guess the User class
FactoryGirl.define do
  factory :user do
    username "user"
    name "Simple User"
    email "dummy@home.de"
    password "12345678" 
    password_confirm "12345678"

    # This will use the User class (Admin would have been guessed)
    factory :admin do
      after(:create) {|user| user.add_role(:admin)}
    end
end
