require 'slack-notifier'
class UpdateController < ApplicationController
	skip_before_action :verify_authenticity_token
	['Content-Type']=='application/json'

def up 
	respond_to do |f|
		f.json {render :json => @info}

		# I know that it IS checking existance by issueID... And it _is_ doing what it
		# is supposed to do. But for some reason, it prints ! and . in every line of 
		# params... and makes no much sense because of that. 

		JSON.parse(request.body.read).each do |item|
			@issueType = params[:fields]["issuetype"]["id"]
			@issueID = params[:id]
			if Info.exists?(:issueID => @issueID.to_i)
					puts "It Exists"
					if :issueType != @issueType.to_i
						puts "Has changed"
					else
						puts "It's the same"
					end
			else
			i = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			i.save
			puts "Doesn't exist"
			
			end
		end
	end

end 
end