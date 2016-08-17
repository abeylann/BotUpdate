require 'slack-notifier'
require 'pagerduty'
class UpdateController < ApplicationController
	include ActiveModel::Dirty
	skip_before_action :verify_authenticity_token

def up
	['Content-Type']=='application/json'
	respond_to do |f|
		f.json {render :json => @info}
			pagerduty = Pagerduty.new("DpUEEvjMnMLGx1ZzRrbd")
			@info = JSON.parse(request.body.read)
			@issueType = params[:issue]["fields"]["issuetype"]["id"]
			@issueID = params[:issue]["id"]
			@description = params[:issue]["fields"]["summary"]
			name = params[:issue]["key"]
			link = "\n For more info, click here: http://deliveroo.atlassian.net/browse/"+ name
			notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#jiraslack', username: 'Incident Updates'
			inf = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))

			if Info.exists?(:issueID => @issueID.to_i)
						issue = Info.find_by_issueID(@issueID)

						if (issue.issueType != @issueType)

							if issue.issueType == 10300 && @issueType == "10004"
								issue.update(issueType: @issueType)
								incident = pagerduty.get_incident(@issueID)
								incident.resolve
								attachment1 = {
									fallback: "Emergency downgraded to bug",
									text: "<!channel> \nIncident " + name + " has now been downgraded to Bug" + link,
									color: "#0078ff"
								}
								notifier.ping attachments:  [attachment1]

							elsif issue.issueType == 10004 && @issueType == "10300"
								issue.update(issueType: @issueType)
								incident2 = pagerduty.trigger(@description)
								attachment2 = {
									fallback:  "Bug upgraded to Emergency",
									text: "<!channel> \nIncident "+ name +" has now been upgraded to Emergency" + link,
									color: "#FF0000"
								}
								notifier.ping attachments: [attachment2]
							end
				end

			else
			inf.save
			end

	end

end
end
