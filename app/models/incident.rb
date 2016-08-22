class Incident
  EMERGENCY = 10300
  BUG = 10004

  def self.from_payload(payload)
	 issue_type = payload["fields"]["issuetype"]["id"]
   jira_id = payload["id"]
	 summary = payload["fields"]["summary"]
	 name = payload["key"]
   new(issue_type: issue_type, jira_id: jira_id, summary: summary, name: name)
  end

  def initialize(issue_type:, jira_id:, summary:, name:)
    @issue_type = issue_type
    @jira_id = jira_id
    @summary = summary
    @name = name
  end

  def bug?
    @issue_type.to_i == BUG
  end

  def emergency?
    @issue_type.to_i == EMERGENCY
  end
 
  def upgraded?(other)
    return unless bug? && other.emergency?

    update(issue_type: EMERGENCY)
  end

  def downgraded?(other)
    return unless emergency? && other.bug?

    update(issue_type: BUG)
  end

  def link
    "http://deliveroo.atlassian.net/browse/#{name}"
  end
end
