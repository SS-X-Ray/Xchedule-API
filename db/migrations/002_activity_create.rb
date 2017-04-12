# 001 migration for db
require 'sequel'

Sequel.migration do
  change do
    create_table(:activity) do
      primary_key :id
      String :possible_time
      String :result_time
    end
  end
end
