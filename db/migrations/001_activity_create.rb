# 001 migration for db
require 'sequel'

Sequel.migration do
  change do
    create_table(:activities) do
      primary_key :id
      String :name
      String :possible_time
      String :result_time
      String :location
    end
  end
end