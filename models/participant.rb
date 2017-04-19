require 'json'
require 'sequel'

# Holds a full Activity's information
class Participant < Sequel::Model
  many_to_one :activity
  def to_json(options = {})
    JSON({ id: id,
           activity_id: activity_id,
           user_id: user_id },
         options)
  end
end
