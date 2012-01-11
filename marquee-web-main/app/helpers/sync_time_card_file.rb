class SyncTimeCardFile
  FTP_SERVER = "10.109.2.114"
  FTP_USER = "userftp"
  FTP_PWD = "@ctive!@#"
  FOLDER = "upload"

  def get_files
    require 'net/ftp'
    require 'net/ftp/list'
    require 'csv'
    
    files_to_get = []

    ftp = Net::FTP.open(FTP_SERVER, FTP_USER, FTP_PWD)
    ftp.list(FOLDER) do |e|
      entry = Net::FTP::List.parse(e)
      files_to_get << entry.basename
    end

    files_to_get.each do |f|
      ftp.getbinaryfile("#{FOLDER}/#{f}")
      ftp.delete("#{FOLDER}/#{f}")
    end

    ftp.close


    files_to_get.each do |f|
      /report_(\d+)_(\d+)_(\d+)_to_(\d+)_(\d+)_(\d+)_.*/ =~ f
      puts "#{$1.to_i} - #{$2.to_i}"
      start_date = Date.new($1.to_i, $2.to_i, $3.to_i)
      end_date = Date.new($4.to_i, $5.to_i, $6.to_i)

      time_card_for_audit = nil
      actual = 0

      CSV.foreach(File.join(Dir.getwd, f)) do |parsed|
        unless parsed[0] == "START_DATE"
          team_member = TeamMember.find_by_name(parsed[2])
          unless team_member.nil?
            from = Date.parse(parsed[0].gsub('_', '/'))
            to = Date.parse(parsed[1].gsub('_', '/'))
            time_card = TimeCard.find_by_name_and_from_and_to(parsed[2], from, to)
            time_card = TimeCard.create if time_card.nil?
            time_card.name = parsed[2]
            time_card.from = from
            time_card.to = to
            time_card.time_working = parsed[4]
            time_card.time_submitted = parsed[5]
            time_card.time_approved = parsed[6]
            time_card.time_rejected = parsed[7]
            time_card.week = time_card.from.cweek
            time_card.save
            time_card_for_audit = time_card
            actual += time_card.time_submitted
          end
        end
      end
      File.delete(File.join(Dir.getwd, f))

      this_week = time_card_for_audit.nil? ? (Date.today - 2).cweek : time_card_for_audit.from.cweek

      TeamMember.scoped.each do |team_member|
        time_card = TimeCard.find_by_name_and_week(team_member.name, this_week)
        if time_card.nil?
          TimeCard.create({
            :name => team_member.name,
            :from => time_card_for_audit.nil? ? (Date.today - 2).beginning_of_week : time_card_for_audit.from,
            :to => time_card_for_audit.nil? ? (Date.today - 2).end_of_week : time_card_for_audit.to,
            :time_working => 0,
            :time_submitted => 0,
            :time_approved => 0,
            :time_rejected => 0,
            :week => this_week,
          })
        end
      end

      unless time_card_for_audit.nil?
        audit_log = TimeCardAuditLog.find_by_week_and_year(time_card_for_audit.from.cweek,time_card_for_audit.from.year)
        audit_log = TimeCardAuditLog.create if audit_log.nil?
        audit_log.year = time_card_for_audit.from.year
        audit_log.week = time_card_for_audit.from.cweek
        audit_log.time_card_needed = TeamMember.count * 40
        audit_log.time_card_actual = actual
        audit_log.save
      end
    end
  end
end