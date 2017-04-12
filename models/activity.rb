require 'json'
require 'sequel'

# Holds a full Activity's information
class Activity < Sequel::Model
  one_to_many :activityusers

  def to_json(options = {})
    JSON({ id: id,
           possible_time: possible_time,
           result_time: result_time },
         options)
  end
end
