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
      if stored_incident.upgraded?(issue)
        PagerDutyIncident.new(issue.id).raise_incident
        IncidentNotifier.new.notify_upgrade(issue)
      end
    else 
      incident.save
      IncidentNotifier.new.notify_new_emergency(issue)
    end
  end
end
