require 'sinatra'

# /api/v1/activity routes only
class XcheduleAPI < Sinatra::Base

  get "/#{API_VER}/activity/:id" do
    content_type 'application/json'

    begin
      activity = Activity.find(id: params[:id])
      output = { Name: activity.name, Location: activity.location,
                 Possible_Time: activity.possible_time,
                 Result_Time: activity.result_time }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET Activity: #{e.inspect}"
      status 404
    end
  end

  post "/#{API_VER}/activity/?" do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      CreateActivityForOrganizer.call(new_data)
    rescue => e
      logger.info "FAILED to create new Activity: #{e.inspect}"
      status 400
    end
    status 201
  end

  post "/#{API_VER}/activity/participant/?" do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      AddParticipantToActivity.call(new_data)
    rescue => e
      logger.info "FAILED to add participant to Activity: #{e.inspect}"
      status 400
    end
    status 201
  end

  patch "/#{API_VER}/activity/?" do
    content_type 'application/json'

    begin
      update_data = JSON.parse(request.body.read)
      UpdateActivity.call(update_data)
    rescue => e
      error_msg = "FAILED to update partial Activity info: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end
    status 201
  end
end
