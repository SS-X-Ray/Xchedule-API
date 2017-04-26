require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    Activity.dataset.destroy
    Account.dataset.destroy
  end

  describe 'Creating new account' do
    before do
      registration_data = { username: 'xraymember', password: 'xraypassword',
                            email: 'xray@xmail.com' }
      @req_body = registration_data.to_json
    end

    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "#{API_VER}/account/", @req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create accounts with duplicate usernames' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "#{API_VER}/account/", @req_body, req_header
      post "#{API_VER}/account/", @req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding an existing account' do
    before do
      @new_account = CreateAccount.call(username: 'xraymember',
                                        password: 'xraypassword',
                                        email: 'xray@xmail.com')
      @new_activities = (1..3).map do |i|
        @new_account.add_organized_activity(name: "Project #{i}")
      end
    end

    it 'HAPPY: should find an existing account' do
      get "#{API_VER}/account/#{@new_account.id}"
      _(last_response.status).must_equal 200

      # results = JSON.parse(last_response.body)
      # _(results['data']['id']).must_equal @new_account.id
      # 3.times do |i|
      #   _(results['relationships'][i]['id']).must_equal @new_projects[i].id
      # endz
    end

    it 'SAD: should not return wrong account' do
      get "#{API_VER}/account/#{random_str(10)}"
      _(last_response.status).must_equal 401
    end
  end
end
