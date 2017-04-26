require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      String :id, type: :uuid, primary_key: true
      foreign_key :organizer_id, :accounts

      String :name
      String :possible_time_secure, text: true
      String :result_time_secure, text: true
      String :location_secure, text: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
