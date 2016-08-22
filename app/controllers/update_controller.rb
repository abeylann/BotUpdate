require 'pagerduty'
class UpdateController < ApplicationController
  include ActiveModel::Dirty
  skip_before_action :verify_authenticity_token

  def up
    ['Content-Type']=='application/json'
    info = JSON.parse(request.body.read)
    incident = Incident.from_payload(info[:issue])

    if incident.emergency?
      EmergencyIncident.process(incident)
    elsif incident.bug?
      BugIssue.process(incident)
    end

    respond_to do |f|
      f.json {render :json => {"status": 200}}

      #Send message slack
      #Check if incident exists
      #Compare Issue type id to see if it's changed
      #Save issue if doesn't exist
    end

  end
end
