require 'sinatra'

# /api/v1/projects routes only
class XcheduleAPI < Sinatra::Base
  def authorized_affiliated_project(env, project_id)
    account = authenticated_account(env)
    all_projects = FindAllAccountProjects.call(id: account['id'])
    all_projects.select { |proj| proj.id == project_id.to_i }.first
  rescue => e
    logger.error "ERROR finding project: #{e.inspect}"
    nil
  end

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

  # get '/api/v1/account/participants/' do
  #   content_type 'application/json'
  #
  #   participant_id = params[:participant_id]
  #   participant = Account[id: participant_id]
  #   halt 404, "Cannot find account #{participant_id}" if participant.nil?
  #
  #   activities = participant.activities
  #
  #   if activities
  #     JSON.pretty_generate(activities: activities)
  #   else
  #     halt 401, "No activities in id #{participant_id}"
  #   end
  # end

  post '/api/v1/account/?' do
    begin
      registration_info = JsonRequestBody.parse_symbolize(request.body.read)
      CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    status 201
  end
end
