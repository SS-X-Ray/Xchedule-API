# 001 migration for db
require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      primary_key :id
      String :name
      String :possible_time_secure, text: true
      String :result_time_secure, text: true
      String :location_secure, text: true
    end
  end
end
