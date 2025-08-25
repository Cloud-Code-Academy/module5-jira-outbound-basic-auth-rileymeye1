public class JiraWrapper {
	private static final String LEAD_ACCOUNT_ID = '712020:5376d4b5-6de3-4d52-80f5-b861678d663f';
	private static final String PROJECT_TEMPLATE_KEY = 'com.pyxis.greenhopper.jira:basic-software-development-template';

	public class ProjectWrapper {
		public String name;
		public String key;
		public String description;
		public String leadAccountId;
		public String projectTemplateKey;

		public ProjectWrapper(String name, String key, String description) {
			this.name = name;
			this.key = key;
			this.description = description;
			this.leadAccountId = LEAD_ACCOUNT_ID;
			this.projectTemplateKey = PROJECT_TEMPLATE_KEY;
		}
	}

	public class IssueWrapper {
		public String name;
		public String key;
		public String description;
		public String projectKey;
		public String summary;
		public String issueType;

		public IssueWrapper(
			String projectKey,
			String summary,
			String description,
			String issueType
		) {
			this.projectKey = projectKey;
			this.summary = summary;
			this.description = description;
			this.issueType = (String.isNotBlank(issueType)) ? issueType : 'Task';
		}

		public Map<String, Object> generateIssuePayloadMap() {
			Map<String, Object> payload = new Map<String, Object>();
			Map<String, Object> fields = new Map<String, Object>();
			
			Map<String, Object> project = new Map<String, Object>();
			project.put('key',this.projectKey);
			fields.put('project', project);
			
			Map<String, Object> issuetype = new Map<String, Object>();
			issuetype.put('name', this.issueType);
			fields.put('issuetype', issuetype);
			
			fields.put('summary', this.summary);
			fields.put('description', formatDescription(this.description));
			
			payload.put('fields', fields);
			return payload;
		}

		private Map<String, Object> formatDescription(String descText) {
			Map<String, Object> description = new Map<String, Object>();
			description.put('type', 'doc');
			description.put('version', 1);
			
			List<Object> content = new List<Object>();
			Map<String, Object> paragraph = new Map<String, Object>();
			paragraph.put('type', 'paragraph');
			
			List<Object> paragraphContent = new List<Object>();
			Map<String, Object> textNode = new Map<String, Object>();
			textNode.put('type', 'text');
			textNode.put('text', descText);
			paragraphContent.add(textNode);
			
			paragraph.put('content', paragraphContent);
			content.add(paragraph);
			description.put('content', content);

			return description;
		}
	}
}
