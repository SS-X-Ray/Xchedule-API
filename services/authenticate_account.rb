# Find account and check password
class AuthenticateAccount
  def self.call(credentials)
    account = Account.first(email: credentials['email'])
    account&.password?(credentials['password']) ? account : nil
  end
end
