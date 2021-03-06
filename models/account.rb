require 'sequel'
require 'json'

# Holds and persists an account's information
class BaseAccount < Sequel::Model
  one_to_many :organized_activities, class: :Activity, key: :organizer_id
  many_to_many :activities,
               join_table: :activities_base_accounts,
               left_key: :participant_id, right_key: :activity_id

  plugin :single_table_inheritance, :type

  plugin :timestamps, update_on_create: true

  plugin :association_dependencies, organized_activities: :destroy

  plugin :whitelist_security
  set_allowed_columns :username, :email, :access_token

  def to_json(options = {})
    JSON({
           type: type,
           id: id,
           username: username,
           email: email,
           access_token: access_token
         }, options)
  end


  def access_token=(ptime_plain)
    self.access_token_secure = SecureDB.encrypt(ptime_plain)
  end

  def access_token
    SecureDB.decrypt(access_token_secure)
  end
end

# Registered accounts with full credentials
class Account < BaseAccount
  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end
  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end

# SSO accounts without passwords
class SsoAccount < BaseAccount
end
