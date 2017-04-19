require_relative './spec_helper'
require 'json'

describe 'Testing Participant resource routes' do
  before do
    Activity.dataset.delete
    Participant.dataset.delete
  end

  describe 'Creating new participants for activity' do
    it 'HAPPY: should add a new participant for an existing activity' do
      existing_activity = Activity.create(name: 'meeting')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: existing_activity.id, user_id: 1 }.to_json
      post '/api/v1/participant/?', req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not add a participant for non-existant activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: "#{invalid_id(Activity)}", user_id: 1 }.to_json
      post '/api/v1/participant/?', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting participants' do
    it 'HAPPY: should find existing participant' do
      activity =  Activity.create(name: 'meeting')
      participant = activity.add_participant(user_id: 1)

      get "api/v1/participant/#{participant.activity_id}"
      _(last_response.status).must_equal 200
      parsed_participant = JSON.parse(last_response.body)
      _(parsed_participant['User_ids'][0]).must_equal participant.user_id
    end

    it 'SAD: should not find non-existant activity and participant' do
      activity_id = invalid_id(Activity)
      get "api/v1/participant/#{activity_id}"
      _(last_response.status).must_equal 404
    end
  end
end
