require 'slack-notifier'
class UpdateController < ApplicationController
	skip_before_action :verify_authenticity_token
	['Content-Type']=='application/json'

def up
	respond_to do |f|
		f.json {render :json => @info}



	# 	JSON.parse(request.body.read).each do |item|
	# 		@issueType = params[:fields]["issuetype"]["id"]
	# 		@issueID = params[:id]
	# 		i = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
	# 		if Info.exists?(:issueID => @issueID.to_i)
	# 				 if Info.where(:issueID == @issueID.to_i && :issueType != @issueType.to_i)
	# 				 	puts "Has changed"
	# 					if Info.where(:issueType == "10300")
	# 					Info.where(:issueID => @issueID.to_i).update(issueType: @issueType.to_i)
	# 					i.save
	# 					puts "yes yes"
	# 					# else
	# 						# puts "not a bug"
	# 					 end
	# 				 else
	# 				  	puts "It's the same"
	# 				end

	# 		else
	# 		i.save
	# 		end
	# 	end
	# end

		JSON.parse(request.body.read).each do |item|
			@issueType = params[:fields]["issuetype"]["id"]
			@issueID = params[:id]
			inf = Info.new(:issueType => (@issueType.to_i), :issueID => (@issueID.to_i))
			if Info.exists?(:issueID => @issueID.to_i)
						puts "It exists!"
					 if Info.where(:issueID == @issueID && :issueType => !@issueType)
					 	puts "Has Changed!"
						#  if Info.where(:issueType == "10300")
						Info.where(:issueID => @issueID).update(issueType: @issueType)
						# inf.save
						#  puts "yes yes"
						# else
						#  puts "not a bug"
						#   end
					# end
				elsif Info.where(:issueID == @issueID && :issueType => @issueType)
				    # else
					  	 puts "It's the same'"
					  	# Info.where(:issueID => @issueID.to_i).update(issueType: @issueType.to_i)
					  	# inf.save
				end

			else
			puts "it's new!!!"
			inf.save
			end
		end
	end

end
end
