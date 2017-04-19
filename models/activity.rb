require 'json'
require 'base64'
require 'sequel'

require_relative '../lib/secure_db'

# Holds a full Activity's information
class Activity < Sequel::Model
  plugin :uuid, field: :id
  one_to_many :participants

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
