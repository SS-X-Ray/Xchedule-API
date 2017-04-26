require_relative './spec_helper'
require 'json'

describe 'Testing Participant resource routes' do
  before do
    Activity.dataset.delete
    Participant.dataset.delete

    @original_password = 'mypassword'
    @acc1 = CreateAccount.call(username: 'xray', email: 'xray@nthu.edu.tw',
                               password: @original_password)
    @acc2 = CreateAccount.call(username: 'xray2', email: 'xray2@nthu.edu.tw',
                               password: @original_password)
  end

  describe 'Creating new participants for activity' do
    it 'HAPPY: should add a new participant for an existing activity' do
      existing_activity = Activity.create(name: 'meeting')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: existing_activity.id, participant_id: @acc1.id }.to_json
      post "/#{API_VER}/activity/participant/?", req_body, req_header
      _(last_response.status).must_equal 201
    end

    it 'SAD: should not add a participant for non-existant activity' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { activity_id: "#{invalid_id(Activity)}", participant_id: @acc1.id }.to_json
      post "/#{API_VER}/activity/participant/?", req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Getting participate activities' do
    it 'HAPPY: should find all activies a account participate' do
      activity = Activity.create(name: 'meeting')
      AddParticipantToActivity.call(activity_id: activity.id, participant_id: @acc1.id)
      get "/#{API_VER}/account/participants/#{@acc1.id}"
      _(last_response.status).must_equal 200
      parsed_activities = JSON.parse(last_response.body)
      _(parsed_activities['activities'][0]).must_equal activity.id
    end

    it 'SAD: should not find activities for not existing account' do
      get "/#{API_VER}/account/participants/#{invalid_id(@acc1.id)}"
      _(last_response.status).must_equal 404
    end
  end
end
