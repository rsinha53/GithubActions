/**
 * Wrapper class for Provider Search Request 
 * Used for both Organization and Practitioner 
 */

public class EPIMProviderSearchRequest {

	public String resourceType = 'Bundle';
	public String id;
	public String type = 'message';
	public List<Entry> entry;
	
    public class Entry {
		public Search search;
		public Request request;
		public Resource resource;
	}
    
	public class Focus {
		public String reference;
	}

	public class Search {
		public String mode;
		public Integer score;
	}

	public class Request {
		public String method;
		public String url;
	}

	public class Resource {
		public String resourceType;	
		public List<Parameter> parameter;
        
		public Event event;
		public String timestamp;
		public Source source;
		public List<Focus> focus;

		public Resource(){

		}

		public Resource(String resourceType, List<Parameter> parameter){
			this.resourceType = resourceType;
			this.parameter = parameter;
		}
	}

	public class Event { //todo - check if this causes issue due to same Keyword as Std Obj
		public String code;
		public String display;
	}

	public class Parameter {
		public String name;
		public String valueString;

		public Parameter(String name, String valueString){
			this.name = name; 
			this.valueString = valueString;
		}
	}

	public class Source {
		public String endpoint;
	}

	
	public static EPIMProviderSearchRequest parse(String json) {
		return (EPIMProviderSearchRequest) System.JSON.deserialize(json, EPIMProviderSearchRequest.class);
	}
}