class SlaveLog
  include Mongoid::Document
  set_database :marquee_remote_host
  field :timestamp, type: Time
  field :level, type: String
  field :message, type: String
  field :fileName, type: String
  field :method, type: String
  field :lineNumber, type: String
  field :ip, type: String

end