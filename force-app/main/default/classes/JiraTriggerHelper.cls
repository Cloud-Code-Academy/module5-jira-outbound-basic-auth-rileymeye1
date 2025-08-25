public with sharing class JiraTriggerHelper {
	public static void processProjectAfterInsert(List<Jira_Project__c> newProjects) {
		List<Jira_Project__c> projectsToProcess = new List<Jira_Project__c>();

		for (Jira_Project__c project : newProjects) {
			// Prevents a recursive call to create the Project in Jira
			if (String.isBlank(project.Project_ID__c)) {
				projectsToProcess.add(project);
			}
		}

		for (Jira_Project__c project : projectsToProcess) {
			JiraCalloutQueueable callout = new JiraCalloutQueueable(
				project.Id,
				project.Project_Name__c,
				project.Project_Key__c,
				project.Description__c
			);

			if (!Test.isRunningTest()) {
				System.enqueueJob(callout);
			}
		}
	}

	public static void processIssueAfterInsert(List<Jira_Issue__c> newIssues) {
		List<Jira_Issue__c> issuesToProcess = new List<Jira_Issue__c>();

		for (Jira_Issue__c issue : newIssues) {
			// Prevents a recursive call to create the Issue in Jira
			if (String.isBlank(issue.Issue_Key__c) && String.isNotBlank(issue.Project_Key__c)) {
				issuesToProcess.add(issue);
			}
		}

		for (Jira_Issue__c issue : issuesToProcess) {
			JiraCalloutQueueable callout = new JiraCalloutQueueable(
				issue.Id,
				issue.Project_Key__c,
				issue.Summary__c,
				issue.Description__c,
				issue.Issue_Type__c
			);

			if (!Test.isRunningTest()) {
				System.enqueueJob(callout);
			}
		}
	}
}
