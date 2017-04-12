require_relative 'config/environments'
require_relative 'models/init'
require 'json'
require 'base64'

# configure based on environment
class XcheduleAPI < Sinatra::Base
  API_VER = 'api/v1'.freeze

  get '/?' do
    'Xchedule web API up at /api/v1'
  end

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
      Activity.create(new_data)
    rescue => e
      logger.info "FAILED to create new Activity: #{e.inspect}"
      status 400
    end
    status 201
  end

  patch "/#{API_VER}/activity/?" do
    content_type 'application/json'

    begin
      update_data = JSON.parse(request.body.read)
      old_record = Activity.find(id: update_data[:id])

      update_data.keys.each do |key|
        if key == :id
          continue
        else
          old_record.send("#{key}=", update_data[key])
          old_record.save
        end
      end
    rescue => e
      logger.info "FAILED to update partial Activity info: #{e.inspect}"
      status 400
    end
  end

  get "/#{API_VER}/participant/:activity_id" do
    content_type 'application/json'

    begin
      participant = Participant.find(activity_id: params[:activity_id])
      output = { User_id: participant.user_id }
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
      Participant.create(new_data)
    rescue => e
      logger.info "FAILED to create new Activity: #{e.inspect}"
      status 400
    end
    status 201
  end
end
