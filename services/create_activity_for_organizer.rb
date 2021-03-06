# Service object to create a new activity for an organizer
class CreateActivityForOrganizer
  def self.call(organizer_id:, name:, location: nil)
    organizer = BaseAccount[id: organizer_id]
    saved_activity = organizer.add_organized_activity(name: name)
    saved_activity.location = location if location
    saved_activity.save
  end
end
