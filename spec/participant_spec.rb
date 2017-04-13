require_relative './spec_helper'

describe 'Testing Configuration resource routes' do
  before do
    Project.dataset.delete
    Configuration.dataset.delete
  end

  describe 'Creating new participants for projects' do
    it 'HAPPY: should add a new participant for an existing activity' do
      existing_project = Activity.create(name: 'meeting')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: existing_project.id, user_id: 1 }.to_json
      post '/api/v1/participant/?',
           req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not add a participant for non-existant activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: "#{invalid_id(Activity)}" , user_id: 1 }.to_json
      post '/api/v1/participant/?',
           req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

    it 'SAD: should catch duplicate participant files within a activity' do
      existing_project = Project.create(name: 'Demo Project')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: existing_project.id, user_id: 1 }.to_json
      url = '/api/v1/participant/?'
      post url, req_body, req_header
      post url, req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting participants' do
    it 'HAPPY: should find existing participant' do
      activity = Activity.create(name: 'meeting')
                      .add_configuration(user_id: 1)
      get "api/v1/participant/#{activity.id}"
      _(last_response.status).must_equal 200
      parsed_config = JSON.parse(last_response.body)['data']['configuration']
      _(parsed_config['type']).must_equal 'configuration'
    end

    it 'SAD: should not find non-existant activity and participant' do
      activity_id = invalid_id(Activity)
      get "api/v1/participant/#{activity_id}"
      _(last_response.status).must_equal 404
    end
  end
end
