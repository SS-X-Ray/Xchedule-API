require 'json'
require 'sequel'

# Holds a full Activity's information
class Activity < Sequel::Model
  one_to_many :particapants

  def to_json(options = {})
    JSON({ id: id,
           name: name,
           possible_time: possible_time,
           result_time: result_time,
           location: location },
         options)
  end
end
