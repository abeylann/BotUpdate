class EmergencyIncident
  def self.process(incident)
    new(incident).process
  end

  def initialize(incident)
    @incident = incident
  end

  def process
    if stored_incident = Incident.find(jira_id: incident.jira_id)
      issue = Incident.find_by_issueID(@issueID)
      if stored_incident.downgraded?(issue)
        PagerDutyIncident.new(issue.id).resolve
        IncidentNotifier.new.notify_downgrade(issue)
      end
    else 
      incident.save
    end
  end
end
