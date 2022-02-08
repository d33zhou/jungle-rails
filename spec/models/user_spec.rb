require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'Validations' do

    it 'should allow a fully completed form to save' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: '12345',
        password_confirmation: '12345'
      })
      @user.save! # using bang as test should error out if save here fails

      expect(@user.id).to be_present
    end

    it 'should verify that a password exists' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: nil,
        password_confirmation: '12345'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Password can't be blank/)
    end

    it 'should verify that a password confirmation exists' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: '12345',
        password_confirmation: nil # not nil, otherwise the default validation is not triggered
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Password confirmation can't be blank/)
    end

    it 'should verify that a password and password confirmation match' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: '12345',
        password_confirmation: '54321'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Password confirmation doesn't match Password/)
    end

    it 'should verify that emails are unique' do
      @user1 = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'TEST@TEST.com',
        password: '12345',
        password_confirmation: '12345'
      })
      @user1.save! # using bang as test should error out if save here fails

      @user2 = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'test@test.COM',
        password: '12345',
        password_confirmation: '12345'
      })
      @user2.save

      expect(@user2.id).not_to be_present
      expect(@user2.errors.full_messages).to include(/Email has already been taken/)
    end

    it 'should verify that a first name exists' do
      @user = User.new({
        first_name: nil,
        last_name: 'Last',
        email: 'first@last.com',
        password: '12345',
        password_confirmation: '12345'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/First name can't be blank/)
    end

    it 'should verify that a last name exists' do
      @user = User.new({
        first_name: 'First',
        last_name: nil,
        email: 'first@last.com',
        password: '12345',
        password_confirmation: '12345'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Last name can't be blank/)
    end

    it 'should verify that an email exists' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: nil,
        password: '12345',
        password_confirmation: '12345'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Email can't be blank/)
    end

    it 'should verify that a password is at least 5 characters long' do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: '123',
        password_confirmation: '123'
      })
      @user.save

      expect(@user.id).not_to be_present
      expect(@user.errors.full_messages).to include(/Password is too short/)
    end

  end

  describe '.authenticate_with_credentials' do

    before do
      @user = User.new({
        first_name: 'First',
        last_name: 'Last',
        email: 'first@last.com',
        password: '12345',
        password_confirmation: '12345'
      })
      @user.save! # using bang as test should error out if save here fails
    end

    it 'should authenticate a user with the correct credentials' do
      @session = User.authenticate_with_credentials('first@last.com', '12345')
      expect(@session).to eq(@user)
    end

    it 'should not authenticate a user with an invalid email' do
      @session = User.authenticate_with_credentials(nil, '12345')
      expect(@session).to be_nil
    end

    it 'should not authenticate a user with an invalid password' do
      @session = User.authenticate_with_credentials('first@last.com', nil)
      expect(@session).to be_nil
    end

    it 'should authenticate a user with the correct credentials, even with extra spaces before/after email' do
      @session = User.authenticate_with_credentials('  first@last.com  ', '12345')
      expect(@session).to eq(@user)
    end

    it 'should authenticate a user with the correct credentials, even with a case insensitive email' do
      @session = User.authenticate_with_credentials('FIRST@LAST.com', '12345')
      expect(@session).to eq(@user)
    end

  end

end
