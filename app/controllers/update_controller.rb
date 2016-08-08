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
			i = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			if Info.exists?(:issueID => @issueID.to_i)
					puts "It Exists"
					if Info.where(:issueID == @issueID.to_i)&&(:issueType == @issueType.to_i)
						puts "It's the same"
					else
						puts "Has changed"
						# i.delete
						# if Info.where (:issueID == @issueID.to_i) do 
						Info.where(:issueID => @issueID.to_i).update(issueType: @issueType.to_i)
						i.save
						
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