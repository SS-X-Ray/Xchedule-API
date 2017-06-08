require 'sinatra'

# /api/v1/accounts authentication related routes
class XcheduleAPI < Sinatra::Base
  post '/api/v1/account/authenticate/?' do
    content_type 'application/json'
    begin
      credentials = JsonRequestBody.parse_symbolize(request.body.read)
      authenticated = AuthenticateAccount.call(credentials)
    rescue => e
      halt 500
      logger.info "Cannot authenticate #{credentials['email']}: #{e}"
    end
    puts "AUTH: #{authenticated}"
    authenticated ? authenticated.to_json : halt(403)
  end

  get '/api/v1/google_account/?' do
    content_type 'application/json'
    begin
      sso_account, auth_token = AuthenticateSsoAccount.new(settings.config).call(params['access_token'])
      { account: sso_account, auth_token: auth_token }.to_json
    rescue => e
      puts e.inspect
      logger.info "FAILED to validate Google account: #{e.inspect}"
      halt 400
    end
  end
end
