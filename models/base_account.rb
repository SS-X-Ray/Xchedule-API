require 'sequel'
require 'json'

# Holds and persists an account's information
class BaseAccount < Sequel::Model
  one_to_many :organized_activities, class: :Activity, key: :organizer_id
  many_to_many :activities,
               join_table: :accounts_activities,
               left_key: :participant_id, right_key: :activity_id

  plugin :timestamps, update_on_create: true

  plugin :association_dependencies, organized_activities: :destroy

  plugin :whitelist_security
  set_allowed_columns :username, :email

  def to_json(options = {})
    JSON({
           type: 'account',
           id: id,
           username: username,
           email: email
         }, options)
  end
end
