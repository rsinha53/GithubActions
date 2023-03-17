public class ICUEDocRequest {

	public String indexName {get;set;}
	public Criteria criteria {get;set;}

    public class Criteria {
		public List<FilterClauses> filterClauses {get;set;}
    }

	public class FilterClauses {
		public String type_Z {get;set;}
		public String name {get;set;}
		public String value {get;set;}
    }

}