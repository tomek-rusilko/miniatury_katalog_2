# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email:"user@example.com", password: "foobar", password_confirmation: "foobar") }
  
  subject { @user } 
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid } 
  end

  describe "when name is too short" do
    before { @user.name = "a" * 2 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    invalid_addresses = %w[ user@foo,com user_at_foo.org user@foo. ]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address}
      it { should_not be_valid }
    end
  end

  describe "when email format is valid" do
    valid_addresses = %w[ user@foo.com USER@foo.org first.last@foo.jp ]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address}
      it { should be_valid }
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password don't match" do
    before { @user.password_confirmation = "sth that doesn't quite match" }
    it { should_not be_valid }
  end

  describe "when a password is to short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid}
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end

  describe "remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


  # let(:attr) { { name: "Example User", email: "user@example.com" } }

  # it "should create a new instance given valid attributes" do
  #   User.create!(attr)
  # end

  # it "should require a name" do
  #   u = User.new(attr.merge name: "")
  #   u.should_not be_valid
  # end

  # it "should require an email" do
  #   u = User.new(attr.merge email: "")
  #   u.should_not be_valid
  # end

  # it "should reject names that are too long" do
  #   long_name = "a" * 51
  #   u = User.new(attr.merge name: long_name)
  #   u.should_not be_valid
  # end

  # it "should reject names that are too short" do
  #   short_name = "a" * 2
  #   u = User.new(attr.merge name: short_name)
  #   u.should_not be_valid
  # end

  # it "should reject invalid email address" do
  #   addresses = %w[ user@foo,com user_at_foo.org user@foo. ]
  #   addresses.each do |a|
  #     u = User.new(attr.merge email: a)
  #     u.should_not be_valid
  #   end
  # end

  # it "should accept valid email address" do
  #   addresses = %w[ user@foo.com USER@foo.org first.last@foo.jp ]
  #   addresses.each do |a|
  #     u = User.new(attr.merge email: a)
  #     u.should be_valid
  #   end
  # end

  # it "should reject duplicate email addresses" do
  #   u1 = User.create!(attr)
  #   u2 = User.new(attr)
  #   u2.should_not be_valid
  # end

  # it "should reject duplicate email addresses up to case" do
  #   email = "tomek@gmail.com"
  #   u1 = User.create!(attr.merge email: email)
  #   u2 = User.new(attr.merge email: email.upcase)
  #   u2.should_not be_valid
  # end
    
end
