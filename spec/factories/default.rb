FactoryGirl.define do

  sequence :email do |n|
    "email.test.#{n}@themihi.net"
  end

  sequence :random_string do |n|
    b = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    (0...20).map{ b[rand(b.length)] }.join
  end

  sequence :number do |n|
    n
  end

end


# Default params
INVALID_EMAILS = [nil, '', 'mihi', 'mihi@', '@themihi', 'gregleuch@themihi']

VALID_USER_OPTS = {:password => "mihi", :password_confirmation => "mihirocks", :email => "gregleuch@themihi.net", :first_name => 'Greg', :last_name => 'Leuch', :zip_code => '10001', :agree_tos => true}
INVALID_USER_OPTS = {}

VALID_SECTION_NAMES = ['tag', 'a tag', 'a longer tag name']
INVALID_SECTION_NAMES = [nil, '', '2 abc', 'a', 'a super really really really really long tag name that should fail max character limit for mihi exhibition']


def failure_test_require_user(a,p={},m=:get)
  lambda {
    case m
      when :get;    get a,p
      when :post;   post a,p
      when :put;    put a,p
      when :delete; delete a,p
      else;         false
    end
  }.should raise_error(Mihi::Unauthorized)
end


def generate_user
  @user = FactoryGirl.create(:user)
end

def generate_user_session(active=true)
  activate_authlogic
  generate_user
  @user_session = UserSession.create(@user)
end

def destroy_user_session
  @user_session.destroy rescue nil
end