require_relative './spec_helper'

describe 'Testing Activity resource routes' do
  before do
    Account.dataset.destroy
    Activity.dataset.destroy

    @original_password = 'mypassword'
    @acc1 = CreateAccount.call(username: 'xray', email: 'xray@nthu.edu.tw',
                               password: @original_password)
    @acc2 = CreateAccount.call(username: 'xray2', email: 'xray2@nthu.edu.tw',
                               password: @original_password)
  end

  describe 'Can organize/add participant a new Activity via a account' do
    it 'should organize one new Activity' do
      @e1 = CreateActivityForOrganizer.call(organizer_id: @acc1.id,
                                            name: 'meeting',
                                            location: 'CTM321')
      @e1.organizer_id.must_equal @acc1.id
    end

    it 'should add a participant to an existing Activity' do
      @acc2.AddParticipantToActivity.call(Activity[id: @e1.id])
      @acc2.activities.first.must_equal @e1
    end
  end
end
