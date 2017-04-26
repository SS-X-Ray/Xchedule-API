# Service object to update activity information
class UpdateActivity
  def self.call(update_data:)
    old_record = Activity[update_data['activity_id']]

    update_data.keys.each do |key|
      if key != 'activity_id'
        old_record.send("#{key}=", update_data[key])
        old_record.save
      end
    end
  end
end
