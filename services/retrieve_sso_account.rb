require 'http'

# Find or create an SsoAccount based on Github code
class AuthenticateSsoAccount
  def initialize(config)
    @config = config
  end

  def call(access_token)
    google_account = get_google_account(access_token)
    sso_account = find_or_create_sso_account(google_account)

    [sso_account, AuthToken.create(sso_account)]
  end

  private_class_method

  def get_google_account(access_token)
    google_account = HTTP.get("https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{access_token}")
                         .parse
    { username: google_account['name'], email: google_account['email'] }
  end

  def find_or_create_sso_account(google_account)
    SsoAccount.first(google_account) || SsoAccount.create(google_account)
  end
end
