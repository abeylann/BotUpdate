class Info < ApplicationRecord

	validates :issueID, :uniqueness => true
	
	
		# def as_json (options= {})
		# response = JSON.parse(request.body.read)

		# response['fields'][1...-1].each do |data|
		# 	# Info.create(
		# 	# 	:issueID => params[:fields]["id"].to_i,
		# 	# 	:issueType => params[:fields]["issuetype"]["id"].to_i
		# 	# 	)
		# 	# Info.save
		# end
		# end
end