class Report::ProjectSeverityBugs
	attr_accessor :sev1_bugs, :sev1_bugs_color, :sev2_bugs, :sev2_bugs_color

	def initialize(sev1_bugs, sev2_bugs)
		@sev1_bugs = sev1_bugs
		@sev1_bugs_color = severity_sev1_color(sev1_bugs)
		@sev2_bugs = sev2_bugs
		@sev2_bugs_color = severity_sev2_color(sev2_bugs)
	end

	def severity_sev1_color(count)
		if count > 0
			return "red"
		else
			return "green"
		end
	end

	def severity_sev2_color(count)
		if count >= 1 and count <=5
			return "yellow"
		elsif count > 5
			return "red"
		else
			return "green"
		end
	end
end