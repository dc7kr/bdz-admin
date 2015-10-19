module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryGirl.create(:admin)

      Rails.logger.debug(admin)
      Rails.logger.debug("----------- KASI --------")

      User.all.each do |u|
        Rails.logger.debug(u.username)
        Rails.logger.debug(u.has_role? :admin)
        
      end
      Rails.logger.debug("----------- KASI --------")
      result = sign_in :user,admin # sign_in(scope, resource)
      Rails.logger.debug("----------- KASI RESULT #{result} --------")
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
end
