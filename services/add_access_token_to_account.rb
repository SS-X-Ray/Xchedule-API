# Add a participant to another organizer's existing activity
class AddAccessTokenToAccount
  def self.call(email:, access_token:)
    account = BaseAccount[email: email]
    account.update(access_token: access_token)
    account.save
  end
end
