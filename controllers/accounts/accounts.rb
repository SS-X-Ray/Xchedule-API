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

  # Create Account when Register
  post '/api/v1/account/?' do
    begin
      registration_info = JsonRequestBody.parse_symbolize(request.body.read)
      new_account = CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s

    status 201
    headers('Location' => new_location)
  end
end
