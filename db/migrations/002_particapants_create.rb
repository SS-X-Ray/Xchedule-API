# 001 migration for db
require 'sequel'

Sequel.migration do
  change do
    create_table(:participants) do
      primary_key :id
      String :activity_id
      String :user_id
    end
  end
end
