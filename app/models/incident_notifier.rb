require 'slack-notifier'

class IncidentNotifier
  def initialize
    @notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: '#jiraslack', username: 'Incident Updates'
  end

  def notify_downgrade(incident)
    attachment1 = {
      fallback: "Emergency downgraded to bug",
      text: "<!channel> \nIncident " + incident.name + " has now been downgraded to Bug" + link(incident),
      color: "#0078ff"
    }
    notifier.ping attachments:  [attachment1]
  end

  def notify_upgrade(incident)
    attachment = {
      fallback:  "Bug upgraded to Emergency",
      text: "<!channel> \nIncident "+ incident.name + " has now been upgraded to Emergency" + link(incident),
      color: "#FF0000"
    }
    notifier.ping attachments:  [attachment]
  end

  private

  def link(incident)
    "\n For more info, click #{incident.link}"
  end
end
