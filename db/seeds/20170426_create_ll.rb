Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, activities'
    create_accounts
    create_activities
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ALL_ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
ALL_ACTIVITIES_INFO = YAML.load_file("#{DIR}/activities_seed.yml")

def create_accounts
  ALL_ACCOUNTS_INFO.each do |account_info|
    CreateAccount.call(account_info)
  end
end

def create_activities
  acti_info_each = ALL_ACTIVITIES_INFO.each
  accounts_cycle = Account.all.cycle
  loop do
    acti_info = acti_info_each.next
    account = accounts_cycle.next
    CreateActivityForOrganizer.call(organizer_id: account.id, name: acti_info[:name],
                               location: acti_info[:location])
  end
end
