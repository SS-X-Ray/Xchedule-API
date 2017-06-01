require 'sinatra'

# /api/v1/accounts authentication related routes
class XcheduleAPI < Sinatra::Base
  post '/api/v1/account/authenticate' do
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
end
