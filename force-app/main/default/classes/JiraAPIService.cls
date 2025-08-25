public with sharing class JiraAPIService {
	private static final String NAMED_CREDENTIAL = 'callout:Jira_API';

	public static String createProject(JiraWrapper.ProjectWrapper projectWrapper) {
		String path = '/project';
		String method = 'POST';
		Map<String, Object> payloadMap = new Map<String, Object>{
			'name' => projectWrapper.name,
			'key' => projectWrapper.key,
			'description' => projectWrapper.description,
			'leadAccountId' => projectWrapper.leadAccountId,
			'projectTemplateKey' => projectWrapper.projectTemplateKey
		};
		String payload = JSON.serialize(payloadMap, true);

		HttpResponse res = jiraCallout(path, method, payload);
		switch on res.getStatusCode() {
			when 201 {
				Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
				return String.valueOf(responseBody.get('id'));
			}
			when else {
				System.debug(res.getStatusCode() + ' ' + res.getStatus() + ': ' + res.getBody());
				return null;
			}
		}
	}

	public static String createIssue(JiraWrapper.IssueWrapper issueWrapper) {
		String path = '/issue';
		String method = 'POST';
		Map<String, Object> payloadMap =  issueWrapper.generateIssuePayloadMap();
		String payload = JSON.serialize(payloadMap, true);

		HttpResponse res = jiraCallout(path, method, payload);
		switch on res.getStatusCode() {
			when 201 {
				Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
				return String.valueOf(responseBody.get('key'));
			}
			when else {
				System.debug(res.getStatusCode() + ' ' + res.getStatus() + ': ' + res.getBody());
				return null;
			}
		}
	}

	public static HttpResponse jiraCallout(String path, String method, String payload) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint(NAMED_CREDENTIAL + path);
		req.setMethod(method);
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Accept', 'application/json');
		req.setTimeout(100000); // 1 minute
		req.setBody(payload);

		Http http = new Http();
		return http.send(req);
	}
}
