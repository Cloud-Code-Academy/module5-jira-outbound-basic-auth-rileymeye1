trigger JiraProjectTrigger on Jira_Project__c(after insert) {
	switch on Trigger.operationType {
		when AFTER_INSERT {
			JiraTriggerHelper.processProjectAfterInsert(Trigger.new);
		}
	}
}
