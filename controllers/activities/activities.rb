require 'sinatra'

# /api/v1/activity routes only
class XcheduleAPI < Sinatra::Base
  get "/#{API_VER}/activity/:id" do
    content_type 'application/json'

    begin
      activity = Activity.find(id: params[:id])
      output = { name: activity.name,
                 id: activity.id,
                 people: activity.participants << activity.organizer,
                 location: activity.location,
                 possible_time: activity.possible_time,
                 result_time: activity.result_time }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET Activity: #{e.inspect}"
      status 404
    end
  end

  # Activity owner add participant to activity
  post "/#{API_VER}/activity/participant/?" do
    content_type 'application/json'

    begin
      new_data = JsonRequestBody.parse_symbolize(request.body.read)
      if AddParticipantToActivity.call(new_data)
        status 201
      else
        halt 400, "No such activity #{new_data[:activity_id]} or is already an organizer #{new_data[:participant_id]}"
      end
    rescue => e
      logger.info "FAILED to add participant to Activity: #{e.inspect}"
      status 400
    end
  end

  # Activity owner update activity info
  patch "/#{API_VER}/activity/?" do
    content_type 'application/json'

    begin
      update_data = JsonRequestBody.parse_symbolize(request.body.read)
      UpdateActivity.call(update_data)
    rescue => e
      error_msg = "FAILED to update partial Activity info: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end
    status 201
  end
end
