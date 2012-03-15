class Report::ProjectSeverityBugs
	attr_accessor :sev1_bugs, :sev1_bugs_color, :sev2_bugs, :sev2_bugs_color

	def initialize(sev1_bugs, sev2_bugs)
		@sev1_bugs = sev1_bugs
		@sev1_bugs_color = severity_color(sev1_bugs)
		@sev2_bugs = sev2_bugs
		@sev2_bugs_color = severity_color(sev2_bugs)
	end

	def severity_color(count)
		if count > 70
			return "red"
		elsif count > 40
			return "yellow"
		else
			return "green"
		end
	end
end