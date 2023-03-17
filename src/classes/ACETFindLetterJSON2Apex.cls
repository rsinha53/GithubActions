public class ACETFindLetterJSON2Apex {

	public class Comment {
		public String text {get;set;} 
		public String dates {get;set;} 

	}
	
	public class WorkItems {
		public List<LetterWorkItem> letterWorkItem {get;set;} 
		public List<LetterWorkItem> workItem {get;set;} 
	}
	
	public class Parameters {

	}
	
	public class ContentType {
		public String type {get;set;} // in json: type
		public String subtype {get;set;} 
		public Parameters parameters {get;set;} 
		public Boolean wildcardType {get;set;} 
		public Boolean wildcardSubtype {get;set;} 
	}
	
	public class Object_Z {
		public WorkItems workItems {get;set;} 
	}
	
	public class Headers {
		public List<String> ContentID {get;set;} 
		public List<String> ContentType {get;set;} 
	}
	
	public class Comments {
		public List<Comment> comment {get;set;} 

		
	}
	
	public class MultipartBody {
		public List<AllAttachments> allAttachments {get;set;} 
		public AllAttachments rootAttachment {get;set;} 
		public List<Parameters> childAttachments {get;set;} 
		public ContentType type {get;set;} // in json: type

		
	}
	
	public class AllAttachments {
		public Headers headers {get;set;} 
		public Object_Z object_Z {get;set;} // in json: object
		public String contentId {get;set;} 
		public ContentType contentType {get;set;} 

		
	}
	
		public MultipartBody MultipartBody {get;set;} 
	
	public class LetterWorkItem {
		public Integer letterId {get;set;} 
		public String externalId {get;set;} 
		public String createdBy {get;set;} 
		public String ownedBy {get;set;} 
		public String lastModifiedDate {get;set;} 
		public Comments comments {get;set;} 
		public String status {get;set;} 

	}
}