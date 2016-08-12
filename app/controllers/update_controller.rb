require 'slack-notifier'
class UpdateController < ApplicationController
	include ActiveModel::Dirty
	skip_before_action :verify_authenticity_token
	['Content-Type']=='application/json'

def up
	respond_to do |f|
		f.json {render :json => @info}

		JSON.parse(request.body.read).each do |item|
			@issueType = params[:fields]["issuetype"]["id"]
			@issueID = params[:id]
			inf = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			if Info.exists?(:issueID => @issueID.to_i)
						puts "It exists!"
						issue = Info.find_by_issueID(@issueID)
						puts issue.issueType
						puts inf.issueType
						puts @issueType

						if (issue.issueType != @issueType)
					 	puts "Not"
						puts issue.issueType
						puts inf.issueType
							if issue.issueType == 10300 && @issueType == "10004"
								issue.update(issueType: @issueType)
								puts "Incident has now been downgraded to Bug"
							elsif issue.issueType == 10004 && @issueType == "10300"
								issue.update(issueType: @issueType)
								puts "Incident has been upgraded to Emergency"
							end
				else
					puts "Same"
				end

			else
			puts "it's new!!!"
			inf.save
			end
		end
	end

end
end
