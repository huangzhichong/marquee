class Report::Project
  include Mongoid::Document
  field :name, type: String

  embeds_many :dres, class_name: "Report::DRE"
  embeds_many :bugs_by_severities, class_name: "Report::BugsBySeverity"
  embeds_many :bugs_by_who_founds, class_name: "Report::BugsByWhoFound"
  embeds_many :technical_debts, class_name: "Report::TechnicalDebt"
  embeds_many :external_bugs_found_by_days, class_name: "Report::ExternalBugsFoundByDay"
  embeds_many :external_bugs_by_day_alls, class_name: "Report::ExternalBugsByDayAll"
  embeds_many :coverages, class_name: "Report::Coverage"
end