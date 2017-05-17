# Find account and check password
class AuthenticateAccount
  def self.call(credentials)
    account = Account.first(email: credentials[:email])
    return nil unless account&.password?(credentials[:password])
    { account: account, auth_token: AuthToken.create(account) }
  end
end
