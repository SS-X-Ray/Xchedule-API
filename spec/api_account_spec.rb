require_relative './spec_helper'

describe 'Testing Account resource routes' do
  describe 'Creating new account' do
    before do
      Activity.dataset.destroy
      Account.dataset.destroy
      registration_data = { username: 'xraymember', password: 'xraypassword',
                            email: 'xray@xmail.com' }
      @req_body = registration_data.to_json
    end

    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "#{API_VER}/account/", @req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not create accounts with duplicate usernames' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "#{API_VER}/account/", @req_body, req_header
      post "#{API_VER}/account/", @req_body, req_header
      _(last_response.status).must_equal 400
    end
  end

  describe 'Finding an existing account' do
    before do
      Activity.dataset.destroy
      Account.dataset.destroy
      @new_account = CreateAccount.call(username: 'xraymember',
                                        password: 'xraypassword',
                                        email: 'xray@xmail.com')
    end

    it 'HAPPY: should find an existing account' do
      get "#{API_VER}/account/#{@new_account.id}"
      _(last_response.status).must_equal 200
    end

    it 'SAD: should not return wrong account' do
      get "#{API_VER}/account/#{SAD_ACCOUNT_ID}"
      _(last_response.status).must_equal 401
    end
  end
end
