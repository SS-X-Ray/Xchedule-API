require 'sequel'

Sequel.migration do
  change do
    create_join_table(participant_id: :base_accounts, activity_id: :activities)
  end
end
