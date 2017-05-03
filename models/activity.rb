require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a full Activity's information
class Activity < Sequel::Model
  many_to_one :organizer, class: :Account
  many_to_many :participants,
               class: :Account, join_table: :accounts_activities,
               left_key: :activity_id, right_key: :participant_id
  plugin :timestamps, update_on_create: true
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

  set_allowed_columns :name, :possible_time, :result_time, :location

  def to_json(options = {})
    JSON({ id: id,
           name: name,
           possible_time: possible_time,
           result_time: result_time,
           location: location },
         options)
  end
end
