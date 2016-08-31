require 'slack-notifier'
require 'pagerduty'
class UpdateController < ApplicationController
	skip_before_action :verify_authenticity_token

def up
	['Content-Type']=='application/json'
	respond_to do |f|
		f.json {render :json => @info}
		 	# pagerduty = Pagerduty.new("DpUEEvjMnMLGx1ZzRrbd")
			@info = JSON.parse(request.body.read)
			@issueType = params[:issue]["fields"]["issuetype"]["id"]
			@issueID = params[:issue]["id"]
			@description = params[:issue]["fields"]["summary"]
			@name = params[:issue]["key"]
			@type = params[:issue]["fields"]["issuetype"]["name"]
			@status = params[:issue]["fields"]["status"]["name"]
			@priority = params[:issue]["fields"]["priority"]["name"]
			@url = ENV["JIRA_URL"]
			slack_update = ENV["SLACK_UPDATE"]
			@notifier_up = Slack::Notifier.new slack_update, channel: '#jiraslack', username: 'Incident Updates'
			@link = "\n For more info, click here: "+ @url + @name
			inf = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))

			if Info.exists?(:issueID => @issueID.to_i)
						issue = Info.find_by_issueID(@issueID)

						if (issue.issueType != @issueType)

							if issue.issueType == 10300 && @issueType == "10004"
								 issue.update(issueType: @issueType)
								 downgraded(inf)
								# incident = pagerduty.get_incident(@issueID)
								# incident.resolve
							elsif issue.issueType == 10004 && @issueType == "10300"
								issue.update(issueType: @issueType)
								upgrade(inf)
								# incident2 = pagerduty.trigger(@description)
							end
						end

			else
			inf.save
			if inf.issueType == 10300
				created(inf)
			end
			end
	end
end

private

def upgrade(inf)
	attachment = {
		fallback:  "Bug upgraded to Emergency",
		text: "<!channel> \nIncident "+ @name +" has now been upgraded to Emergency" + @link,
		color: "#FF0000"
	}
	@notifier_up.ping attachments: [attachment]
end

def downgraded (inf)
	attachment1 = {
		fallback: "Emergency downgraded to bug",
		text: "<!channel> \nIncident " + @name + " has now been downgraded to Bug" + @link,
		color: "#0078ff"
	}
	@notifier_up.ping attachments:  [attachment1]
end

def created(inf)
	slack_new = ENV["SLACK_NEW"]
	attachment_new = {
				fallback: "New emergency",
				text: "<!channel>" +"\n Type: " + @type + "\n Incident: " + @name + "\n Summary: "+ @description+"\n Status: "+ @status +"\n Priority: "+ @priority + @link,
				color: '#ff0000'
			}
			notifier = Slack::Notifier.new slack_new, channel: '#jiraslack', username: 'Incident'
			notifier.ping attachments: [attachment_new]
end

end
