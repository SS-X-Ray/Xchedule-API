# 001 migration for db
require 'sequel'

Sequel.migration do
  change do
    create_table(:participants) do
      primary_key :id
      foreign_key :activity_id
      String :user_id
    end
  end
end
