require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/schedule'

# configure based on environment
class XcheduleAPI < Sinatra::Base
  configure do
    enable :logging
    Schedule.setup
  end

  API_VER = 'api/v1'.freeze

  get "/#{API_VER}/schedule/" do
    content_type 'application/json'

    output = { Schedule_id: Schedule.all }
    JSON.pretty_generate(output)
  end

  get "/#{API_VER}/schedule/:id.json" do
    content_type 'application/json'

    begin
      output = { Schedule: Schedule.find(params[:id]) }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET Schedule: #{e.inspect}"
      status 404
    end
  end

  post "/#{API_VER}/schedule/?" do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_timeseries = Schedule.new(new_data)
      if new_timeseries.save
        logger.info "NEW Schedule STORED: #{new_timeseries.id}"
      else
        halt 400, "Could not store timeseries: #{new_timeseries}"
      end

      redirect "/#{API_VER}/schedule/" + new_timeseries.id.to_s + '.json'
    rescue => e
      logger.info "FAILED to create new timeseries: #{e.inspect}"
      status 400
    end
  end
end
