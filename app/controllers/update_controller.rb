require 'slack-notifier'
class UpdateController < ApplicationController
	include ActiveModel::Dirty
	skip_before_action :verify_authenticity_token

def up
	['Content-Type']=='application/json'
	respond_to do |f|
		f.json {render :json => @info}
			@info = JSON.parse(request.body.read)
			@issueType = params[:fields]["issuetype"]["id"]
			@issueID = params[:id]
			@name = params[:key]
			inf = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			if Info.exists?(:issueID => @issueID.to_i)
						issue = Info.find_by_issueID(@issueID)

						if (issue.issueType != @issueType)

							if issue.issueType == 10300 && @issueType == "10004"
								issue.update(issueType: @issueType)
								notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#jiraslack', username: 'Incidents Updates'
								notifier.ping "<!channel> Incident " + @name + " has now been downgraded to Bug"
								puts "Incident " + @name + " has now been downgraded to Bug"
							elsif issue.issueType == 10004 && @issueType == "10300"
								issue.update(issueType: @issueType)
								notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#jiraslack', username: 'Incidents Updates'
								notifier.ping "<!channel> Incident " + @name + " has now been upgraded to Bug"
								puts "Incident " + @name + " has been upgraded to Emergency"
							end
				end

			else
			inf.save
			end

	end

end
end
