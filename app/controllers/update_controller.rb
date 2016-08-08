require 'slack-notifier'
class UpdateController < ApplicationController
	skip_before_action :verify_authenticity_token
	['Content-Type']=='application/json'

def up 
	respond_to do |f|
		f.json {render :json => @info}

		

		JSON.parse(request.body.read).each do |item|
			@issueType = params[:fields]["issuetype"]["id"]
			@issueID = params[:id]
			i = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			if Info.exists?(:issueID => @issueID.to_i)
					puts "It Exists"
					if Info.where(:issueID == @issueID.to_i)&&(:issueType != @issueType.to_i)
						puts "Has changed"
						Info.where(:issueID => @issueID.to_i).update(issueType: @issueType.to_i)
						i.save
					else
						puts "It's the same"
					end
					
			else
			i.save
			puts "Doesn't exist"
			
			end

			puts Info.count
		end
	end

end 
end