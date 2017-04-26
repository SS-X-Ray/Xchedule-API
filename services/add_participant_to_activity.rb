# Add a participant to another organizer's existing activity
class AddParticipantToActivity
  def self.call(participant_id:, activity_id:)
    participant = Account[id: participant_id]
    return false if activity.organizer.id == participant.id
    participant.add_activity(activity_id)
    participant
  end
end
