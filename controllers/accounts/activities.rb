require 'sinatra'

# /api/v1/activities routes only
class XcheduleAPI < Sinatra::Base
  # Get all activities for an account
  get '/api/v1/accounts/:id/activities/?' do
    content_type 'application/json'

    begin
      id = params[:id]
      halt 401 unless authorized_account?(env, id)
      all_activities = FindAllAccountActivities.call(id: id)
      JSON.pretty_generate(data: all_activities)
    rescue => e
      logger.info "FAILED to find activities for user: #{e}"
      halt 404
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
