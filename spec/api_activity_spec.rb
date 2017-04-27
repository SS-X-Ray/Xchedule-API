require_relative './spec_helper'

describe 'Testing Activity resource routes' do
  before do
    Activity.dataset.destroy
    Account.dataset.destroy
    @original_password = 'mypassword'
    @acc1 = CreateAccount.call(username: 'xray', email: 'xray@nthu.edu.tw',
                               password: @original_password)
    @acc2 = CreateAccount.call(username: 'xray2', email: 'xray2@nthu.edu.tw',
                               password: @original_password)
    @new_activity = CreateActivityForOrganizer.call(organizer_id: @acc1.id,
                                                    name: 'meeting',
                                                    location: 'CTM321')
  end
  describe 'Can create a new Activity for an organizer' do
    it 'HAPPY: should create a new unique Activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { organizer_id: @acc1.id, name: 'Meeting' }.to_json
      post '/api/v1/activity/', req_body, req_header
      _(last_response.status).must_equal 201
    end
  end

  describe 'Can find existing activity' do
    it 'HAPPY: should find an existing activity' do
      get "/api/v1/activity/#{@new_activity.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['Name']).must_equal new_activity.name
    end

    it 'SAD: should not find non-existent activity' do
      get "/api/v1/activity/#{invalid_id(@new_activity.id)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Adding possible time and result time' do
    it 'HAPPY: should add a list of possible time to existing activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: @new_activity.id, possible_time: '[1, 2, 3]' }.to_json
      patch '/api/v1/activity/', req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not add a list of possible_time to non-existing activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: "#{invalid_id(@new_activity.id)}", possible_time: '[1, 2, 3]' }.to_json
      patch '/api/v1/activity/', req_body, req_header
      _(last_response.status).must_equal 400
    end

    it 'HAPPY: should add result time to existing activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: @new_activity.id, result_time: '1' }.to_json
      patch '/api/v1/activity/', req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not add result time to non-existing activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: "#{invalid_id(@new_activity.id)}", result_time: '1' }.to_json
      patch '/api/v1/activity/', req_body, req_header
      _(last_response.status).must_equal 400
    end
  end
end
