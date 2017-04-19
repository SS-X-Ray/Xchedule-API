require 'sinatra'

# /api/v1/participant routes
class XcheduleAPI < Sinatra::Base
  get "/#{API_VER}/participant/:activity_id" do
    content_type 'application/json'

    begin
      participants = Activity.find(id: params[:activity_id]).participants
      participants.map!(&:user_id)
      output = { User_ids: participants }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET Participant: #{e.inspect}"
      status 404
    end
  end

  post "/#{API_VER}/participant/?" do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      activity = Activity[new_data['activity_id']]
      activity.add_participant(user_id: new_data['user_id'])
    rescue => e
      error_msg = "FAILED to create new participant in activity: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end
    status 201
  end
end
