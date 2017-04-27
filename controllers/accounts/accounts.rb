require 'sinatra'

# /api/v1/projects routes only
class XcheduleAPI < Sinatra::Base
  get '/api/v1/account/:id' do
    content_type 'application/json'

    id = params[:id]
    account = Account.where(id: id).first

    if account
      activities = account.organized_activities
      JSON.pretty_generate(data: account, relationships: activities)
    else
      halt 401, "ACCOUNT NOT VALID: #{id}"
    end
  end

  get 'api/v1/account/participants/:participant_id' do
    content_type 'application/json'

    participant_id = params[:participant_id]
    participant = Account[id: participant_id]
    activities = participant.activities

    if activities
      JSON.pretty_generate(acitivities: activities)
    else
      halt 401, "No activities in id #{participant_id}"
    end
  end

  post '/api/v1/account/?' do
    begin
      registration_info = JsonRequestBody.parse_symbolize(request.body.read)
      new_account = CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    status 201
  end
end
