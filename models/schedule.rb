require 'json'
require 'base64'
require 'rbnacl/libsodium'

# Holds a full schedule document information
class Schedule
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :time

  def initialize(new_user_schedule)
    @id = new_user_schedule['id'] || new_id
    @time = new_user_schedule['time']
  end

  def new_id
    Base64.urlsafe_encode64(RbNaCl::Hash.sha256(Time.now.to_s))[0..9]
  end

  def to_json(options = {})
    JSON({ id: @id,
           time: @time },
         options)
  end

  def save
    File.open(STORE_DIR + @id.to_s + '.txt', 'w') do |file|
      file.write(to_json)
    end

    true
  rescue
    false
  end

  def self.find(find_id)
    timeseries_file = File.read(STORE_DIR + find_id + '.txt')
    Schedule.new JSON.parse(timeseries_file)
  end

  def self.all
    Dir.glob(STORE_DIR + '*.txt').map do |filename|
      filename.match(/#{Regexp.quote(STORE_DIR)}(.*)\.txt/)[1]
    end
  end

  def self.setup
    Dir.mkdir(Schedule::STORE_DIR) unless Dir.exist? STORE_DIR
  end
end
