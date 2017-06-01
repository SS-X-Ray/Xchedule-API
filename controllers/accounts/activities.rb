require 'sinatra'

# /api/v1/activities routes only
class XcheduleAPI < Sinatra::Base
  # Get all activities for an account
  get '/api/v1/accounts/:account_id/activities/?' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      target_account = BaseAccount[params[:account_id]]

      viewable_activities =
        ActivityPolicy::Scope.new(requesting_account, target_account).viewable
      JSON.pretty_generate(data: viewable_activities)
    rescue
      error_msg = "FAILED to find activities for user: #{params[:account_id]}"
      logger.info error_msg
      halt 404, error_msg
    end
  end

  # Make a new activity
  post '/api/v1/accounts/:id/organized_activities/?' do
    begin
      new_data = JsonRequestBody.parse_symbolize(request.body.read)
      saved_activity = CreateActivityForOrganizer.call(new_data)
      new_location = URI.join(@request_url.to_s + '/',
                              saved_activity.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new activity: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end
end
