require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a full Activity's information
class Activity < Sequel::Model
  many_to_one :organizer, class: :BaseAccount
  many_to_many :participants,
               class: :BaseAccount, join_table: :activities_base_accounts,
               left_key: :activity_id, right_key: :participant_id
  plugin :timestamps, update_on_create: true

  plugin :whitelist_security
  set_allowed_columns :name, :possible_time, :result_time, :location

  plugin :association_dependencies
  add_association_dependencies participants: :nullify

  def possible_time=(ptime_plain)
    self.possible_time_secure = SecureDB.encrypt(ptime_plain)
  end

  def possible_time
    SecureDB.decrypt(possible_time_secure)
  end

  def result_time=(rtime_plain)
    self.result_time_secure = SecureDB.encrypt(rtime_plain)
  end

  def result_time
    SecureDB.decrypt(result_time_secure)
  end

  def location=(location_plain)
    self.location_secure = SecureDB.encrypt(location_plain)
  end

  def location
    SecureDB.decrypt(location_secure)
  end

  def to_json(options = {})
    JSON({ id: id,
           attributes: {
             name: name,
             possible_time: possible_time,
             result_time: result_time,
             location: location
           },
           relationships: {
             organizer: organizer,
             participants: participants
           }
         },
         options)
  end
end
