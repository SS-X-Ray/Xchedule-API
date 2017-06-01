# Add a participant to another organizer's existing activity
class AddParticipantToActivity
  def self.call(participant_id:, activity_id:)
    participant = BaseAccount[id: participant_id]
    activity = Activity[id: activity_id]
    return false if activity.nil?
    return false if activity.organizer_id == participant.id
    participant.add_activity(activity_id)
    participant
  end
end
