public class JiraCalloutQueueable implements Queueable, Database.AllowsCallouts {
	// Simple constants instead of enum
	public static final String TYPE_PROJECT = 'PROJECT';
	public static final String TYPE_ISSUE = 'ISSUE';

	private String calloutType;
	private Id recordId;
	private JiraWrapper.ProjectWrapper projectWrapper;
	private JiraWrapper.IssueWrapper issueWrapper;

	/**
	 * Constructor for Jira Project callout
	 * @param recordId The Salesforce Jira Project record Id
	 * @param projectName The name of the project
	 * @param projectKey The unique key for the project
	 * @param description Project description
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectName,
		String projectKey,
		String description
	) {
		this.calloutType = TYPE_PROJECT;
		this.recordId = recordId;
		this.projectWrapper = new JiraWrapper.ProjectWrapper(projectName, projectKey, description);
	}

	/**
	 * Constructor for Jira Issue callout
	 * @param recordId The Salesforce Jira Issue record Id
	 * @param projectKey The project key where the issue should be created
	 * @param summary The issue summary/title
	 * @param description Issue description
	 * @param issueType The type of issue
	 */
	public JiraCalloutQueueable(
		Id recordId,
		String projectKey,
		String summary,
		String description,
		String issueType
	) {
		this.calloutType = TYPE_ISSUE;
		this.recordId = recordId;
		this.issueWrapper = new JiraWrapper.IssueWrapper(projectKey, summary, description, issueType);
	}

	public void execute(QueueableContext context) {
		switch on this.calloutType {
			when 'PROJECT' {
				String jiraProjectId = JiraAPIService.createProject(this.projectWrapper);
				updateJiraProject(jiraProjectId);
			}
			when 'ISSUE' {
				String jiraIssueKey = JiraAPIService.createIssue(this.issueWrapper);
				updateJiraIssue(jiraIssueKey);
			}
		}
	}

	private void updateJiraProject(String jiraProjectId) {
		Database.update(new Jira_Project__c(Id = this.recordId, Project_ID__c = jiraProjectId), AccessLevel.SYSTEM_MODE);
	}

	private void updateJiraIssue(String jiraIssueKey) {
		Database.update(new Jira_Issue__c(Id = this.recordId, Issue_Key__c = jiraIssueKey, Last_Updated__c = Datetime.now()), AccessLevel.SYSTEM_MODE);
	}
}
