require 'econfig'
require 'sinatra'

# configure based on environment
class XcheduleAPI < Sinatra::Base
  extend Econfig::Shortcut
  API_VER = 'api/v1'.freeze

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureDB.setup(settings.config.DB_KEY)
    AuthToken.setup(settings.config.TOKEN_KEY)
  end

  def secure_request?
    request.scheme.casecmp(settings.config.SECURE_SCHEME).zero?
  end

  def authenticated_account(env)
    scheme, auth_token = env['HTTP_AUTHORIZATION'].split(' ')
    return nil unless scheme.match?(/^Bearer$/i)
    account_payload = AuthToken.payload(auth_token)
    Account[account_payload['id']]
    # scheme.match?(/^Bearer$/i) ? account_payload : nil
  end

  def authorized_account?(env, id)
    account = authenticated_account(env)
    account['id'].to_s == id.to_s
  rescue
    false
  end

  before do
    halt(403, 'Use HTTPS only') unless secure_request?

    host_url = "#{settings.config.SECURE_SCHEME}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  def secure_request?
    request.scheme.casecmp(settings.config.SECURE_SCHEME).zero?
  end

  before do
    halt(403, 'Use HTTPS only') unless secure_request?

    host_url = "#{settings.config.SECURE_SCHEME}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Xchedule web API up at /api/v1'
  end
end
