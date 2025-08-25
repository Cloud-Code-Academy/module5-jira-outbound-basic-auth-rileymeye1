trigger JiraIssueTrigger on Jira_Issue__c(after insert) {
	switch on Trigger.operationType {
		when AFTER_INSERT {
			JiraTriggerHelper.processIssueAfterInsert(Trigger.new);
		}
	}
}
