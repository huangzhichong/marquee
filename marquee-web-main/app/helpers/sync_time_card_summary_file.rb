class SyncTimeCardSummaryFile
  FTP_SERVER = "10.109.2.114"
  FTP_USER = "oracletimecard"
  FTP_PWD = "@ctive123"
  FOLDER = "summary"

  @queue = :marquee_data_sync

  def self.perform
    require 'net/sftp'
    require 'csv'

    Net::SFTP.start(FTP_SERVER, FTP_USER, :password => FTP_PWD) do |sftp|
      files_to_get = {}
      files = []

      sftp.dir.foreach(FOLDER) do |entry|
        files << entry.name unless entry.directory?
      end

      # puts files
      files.each do |name|
        files_to_get[name] = sftp.download!("#{FOLDER}/#{name}")
      end

      files_success, files_failed = import files_to_get

      # puts "successed ::#{files_success}"
      # puts "failed::#{files_failed}"
      files_success.each do |file|
        sftp.rename!("#{FOLDER}/#{file}", "#{FOLDER}/successed/#{file}")
      end
      files_failed.each do |file|
        sftp.rename!("#{FOLDER}/#{file}", "#{FOLDER}/failed/#{file}")
      end

    end
  end

  def self.createJob
    Resque.enqueue(SyncTimeCardFile)
  end

  private
  def self.find_member_by_name(name)
    member = TeamMember.find_by_name(name)
    if member.nil?
      new_member = TeamMember.new
      new_member.name = name
      new_member.cc_list = 'marquee@activenetwork.com'
      new_member.save
      member = new_member
    end
    member
  end

  def self.insert_time_card(name, from, to, amount, status)
    existing_time_card_record = TimeCard.find_by_name_and_from(name, from)
    if existing_time_card_record and existing_time_card_record.time_approved >= 40
      if existing_time_card_record.time_working > 0 or
          existing_time_card_record.time_submitted > 0 or
          existing_time_card_record.time_rejected > 0
        existing_time_card_record.time_working = existing_time_card_record.time_submitted = existing_time_card_record.time_rejected = 0
        existing_time_card_record.save
      end
      puts "already have correct (approved >= 40) timecard in database, skip this row"
    else
      time_working = time_submitted = time_approved = time_rejected = 0

      if status == "WORKING"
        time_working = amount
      elsif status == "SUBMITTED"
        time_submitted = amount
      elsif status == "APPROVED"
        time_approved = amount
      elsif status == "REJECTED"
        time_rejected = amount
      end

      if existing_time_card_record.nil?
        timecard = TimeCard.create
        timecard.name = name
        timecard.from = from
        timecard.to = to
        timecard.time_working = timecard.time_submitted = timecard.time_approved = timecard.time_rejected = 0
        timecard.week = from.cweek
        timecard.save
      else
        timecard = existing_time_card_record
      end

      timecard.time_working = timecard.time_working + time_working
      timecard.time_submitted = timecard.time_submitted + time_submitted
      timecard.time_approved = timecard.time_approved + time_approved
      timecard.time_rejected = timecard.time_rejected + time_rejected

      if timecard.time_approved >= 40
        timecard.time_submitted = timecard.time_working = timecard.time_rejected = 0
      end

      timecard.save
    end
  end

  def self.import(files_to_get)
    files_success = []
    files_failed = []

    files_to_get.each do |path, f|
      begin
        TimeCard.transaction do
          CSV.parse(f) do |row|
            unless row[0] == "Customer Name"
              period = row[8]
              name = row[10]
              amount = row[6].to_i
              status = row[20]
              puts "timecard entry for #{name}, period: #{period}, amount: #{amount}, status: #{status}"

              /(\d+)\/(\d+)\/(\d+)\s-\s(\d+)\/(\d+)\/(\d+)/ =~ period
              from = Date.parse("#{$3}-#{$1}-#{$2}")
              to = Date.parse("#{$6}-#{$4}-#{$5}")

              member = SyncTimeCardSummaryFile.find_member_by_name(name)
              SyncTimeCardSummaryFile.insert_time_card(name, from, to, amount, status)
            end
          end
        end
        files_success << path
      rescue
        puts "file #{path} import failed, will move to directory:failded"
        files_failed << path
        next
      end
    end
    return files_success, files_failed
  end
end
