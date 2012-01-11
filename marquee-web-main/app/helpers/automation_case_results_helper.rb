module AutomationCaseResultsHelper
  def format_error_message(error_message)
    regex = /(\[\d+-\d+-\d+\s*\d+:\d+:\d+\])/
    errors = error_message.split(regex)
    #TODO: error handling
    safe_concat("<p>")
    1.upto(errors.length - 1) do |i|
      next if i%2 == 0
      datetime = errors[i]
      message = errors[i+1]
      safe_concat("<p><span class='datetime'>" + datetime + "</span>")
      safe_concat("<span class='message'>" + message + "</span></p>")
    end
    safe_concat("</p>")
  end
end
