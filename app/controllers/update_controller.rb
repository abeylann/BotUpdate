require 'slack-notifier'
class UpdateController < ApplicationController
	skip_before_action :verify_authenticity_token
	['Content-Type']=='application/json'

def up 
	respond_to do |f|
		f.json {render :json => @info}

		JSON.parse(request.body.read).each do |item|
			@type = params[:fields]["issuetype"]["id"]
			@issue = params[:id]
			i = Info.new(:issueType => (@type.to_i), :issueID => (@issue.to_i))
			i.save
		end
	end

end 
end
